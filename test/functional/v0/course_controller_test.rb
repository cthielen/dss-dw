require 'test_helper'

class Api::V0::CoursesControllerTest < ActionController::TestCase
  test "invalid user should get denied" do
    get :index
    
    assert_response :unauthorized
  end

  test "valid user should get access" do
    grant_whitelisted_access

    get :index

    assert_response :success
    assert_not_nil assigns(:courses)
  end
end
