ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  include Authorization::TestHelper
  
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def grant_whitelisted_access
    @request.env['REMOTE_ADDR'] = '1.2.3.4'
  end
end
