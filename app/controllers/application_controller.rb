class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include Authentication
  before_filter :authenticate
end
