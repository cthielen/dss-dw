require 'test_helper'

class Api::V0::TermsControllerTest < ActionController::TestCase
  test "invalid user should get denied" do
    get :index
    
    assert_response :unauthorized
  end

  test "valid whitelisted user should get access" do
    grant_whitelisted_access

    get :index

    assert_response :success
    assert_not_nil assigns(:terms)
  end
  
  test 'term index JSON request must include certain attributes' do
    grant_whitelisted_access

    get :index, :format => :json

    body = JSON.parse(response.body)[0]["term"]

    assert body.include?('id'), 'JSON response should include id field'
    assert body.include?('code'), 'JSON response should include code field'
    assert body.include?('description'), 'JSON response should include description field'
  end
  
end
