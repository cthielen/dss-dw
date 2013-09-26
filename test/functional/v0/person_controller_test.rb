require 'test_helper'

class Api::V0::PeopleControllerTest < ActionController::TestCase
  test "invalid user should get denied" do
    get :index
    
    assert_response :unauthorized
  end

  test "valid whitelisted user should get access" do
    grant_whitelisted_access

    get :index

    assert_response :success
    assert_not_nil assigns(:people)
  end
  
  test 'people index JSON request must include certain attributes' do
    grant_whitelisted_access

    get :index, :format => :json

    body = JSON.parse(response.body)[0]["person"]

    assert body.include?('iam_id'), 'JSON response should include iam_id field'
    assert body.include?('first'), 'JSON response should include first field'
    assert body.include?('last'), 'JSON response should include last field'
    assert body.include?('loginid'), 'JSON response should include loginid field'
  end

  test 'person show JSON request must include certain attributes' do
    grant_whitelisted_access

    get :show, :format => :json, :id => "fmlast"

    body = JSON.parse(response.body)["person"]

    assert body.include?('iam_id'), 'JSON response should include iam_id field'
    assert body.include?('first'), 'JSON response should include first field'
    assert body.include?('last'), 'JSON response should include last field'
    assert body.include?('loginid'), 'JSON response should include loginid field'
  end  
end
