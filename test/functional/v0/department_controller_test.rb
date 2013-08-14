require 'test_helper'

class Api::V0::DepartmentsControllerTest < ActionController::TestCase
  test "invalid user should get denied" do
    get :index
    
    assert_response :unauthorized
  end

  test "valid whitelisted user should get access" do
    grant_whitelisted_access

    get :index

    assert_response :success
    assert_not_nil assigns(:departments)
  end
  
  test 'department index JSON request must include certain attributes' do
    grant_whitelisted_access

    get :index, :format => :json

    body = JSON.parse(response.body)[0]["department"]

    assert body.include?('id'), 'JSON response should include id field'
    assert body.include?('code'), 'JSON response should include code field'
    assert body.include?('description'), 'JSON response should include description field'
  end

  test 'department show JSON request must include certain attributes' do
    grant_whitelisted_access

    get :show, :format => :json, :id => 'HIS'

    body = JSON.parse(response.body)["department"]

    assert body.include?('id'), 'JSON response should include id field'
    assert body.include?('code'), 'JSON response should include code field'
    assert body.include?('description'), 'JSON response should include description field'
  end  
end
