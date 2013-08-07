module Authentication
  # Returns the current_user, which may be 'false' if impersonation is active
  def current_user
    case session[:auth_via]
    when :whitelisted_ip
      return ApiWhitelistedIpUser.find_by_address(session[:user_id])
    when :api_key
      return ApiKeyUser.find_by_name(session[:user_id])
    end
  end
  
  # Ensure session[:auth_via] exists.
  # This is populated by a whitelisted IP request, a CAS redirect or a HTTP Auth request
  def authenticate
    if session[:auth_via]
      case session[:auth_via]
      when :whitelisted_ip
        #Authorization.current_user = ApiWhitelistedIpUser.find_by_address(session[:user_id])
      when :api_key
        #Authorization.current_user = ApiKeyUser.find_by_name(session[:user_id])
      end
      #logger.info "User authentication passed due to existing session: #{session[:auth_via]}, #{Authorization.current_user}"
      return
    end

    @whitelisted_user = ApiWhitelistedIpUser.find_by_address(request.remote_ip)
    # Check if the IP is whitelisted for API access (used with Sympa)
    if @whitelisted_user
      logger.info "API authenticated via whitelist IP: #{request.remote_ip}"
      session[:user_id] = request.remote_ip
      session[:auth_via] = :whitelisted_ip
      #Authorization.current_user = @whitelisted_user
      
      #Authorization.ignore_access_control(true)
      @whitelisted_user.logged_in_at = DateTime.now()
      @whitelisted_user.save
      #Authorization.ignore_access_control(false)
      return
    else
      logger.debug "authenticate: Not on the API whitelist."
    end

    # Check if HTTP Auth is being attempted.
    authenticate_with_http_basic { |name, secret|
      @api_user = ApiKeyUser.find_by_name_and_secret(name, secret)

      if @api_user
        logger.info "API authenticated via application key"
        session[:user_id] = name
        session[:auth_via] = :api_key
        Authorization.current_user = @api_user
        Authorization.ignore_access_control(true)
        @api_user.logged_in_at = DateTime.now()
        @api_user.save
        Authorization.ignore_access_control(false)
        return
      end

      logger.info "API authentication failed. Application key is wrong."
      # Note that they will only get 'access denied' if they supplied a name and
      # failed. If they supplied nothing for HTTP Auth, this block will get passed
      # over.
      render :text => "Invalid API key.", :status => 401
      return
      #raise ActionController::RoutingError.new('Access denied')
    }

    logger.debug "Passed over HTTP Auth. No authentication methods remain."

    # User not in our database.
    session[:user_id] = nil
    session[:auth_via] = nil

    head :unauthorized
    #redirect_to :controller => "site", :action => "access_denied"
  end
end
