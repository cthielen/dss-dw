module Api
  module V0
    class TermsController < ApplicationController
      before_filter :load_term, :only => :show
      before_filter :new_term_from_params, :only => :create
      filter_access_to :all, :attribute_check => true
      filter_access_to :index, :attribute_check => true, :load_method => :load_terms
      
      def index
        logger.info "#{current_user.log_identifier}@#{request.remote_ip}: Loaded terms index."
        
        render "api/v0/terms/index"
      end
      
      private
      
      def load_terms
        @terms = Term.all
      end
    end
  end
end
