require 'test_helper'

class Api::V0::CoursesControllerTest < ActionController::TestCase
  test "invalid user should get denied" do
    get :index
    
    assert_response :unauthorized
  end

  test "valid whitelisted user should get access" do
    grant_whitelisted_access

    get :index

    assert_response :success
    assert_not_nil assigns(:courses)
  end
  
  test 'department nested course index JSON request must include certain attributes' do
    grant_whitelisted_access

    get :index, :format => :json, :department_id => 'HIS'

    body = JSON.parse(response.body)[0]["course"]

    assert body.include?('college_code'), 'JSON response should include college_code field'
    assert body.include?('crn'), 'JSON response should include CRN field'
    assert body.include?('start_date'), 'JSON response should include start_date field'
    assert body.include?('end_date'), 'JSON response should include end_date field'
    assert body.include?('number'), 'JSON response should include number field'
    assert body.include?('title'), 'JSON response should include title field'
    assert body.include?('instructor_id'), 'JSON response should include instructor_id field'
    assert body.include?('instructor_first'), 'JSON response should include instructor_first field'
    assert body.include?('instructor_middle'), 'JSON response should include instructor_middle field'
    assert body.include?('instructor_last'), 'JSON response should include instructor_last field'
  end

  test 'course index JSON request must include certain attributes' do
    grant_whitelisted_access

    get :index, :format => :json

    body = JSON.parse(response.body)[0]["course"]

    assert body.include?('college_code'), 'JSON response should include college_code field'
    assert body.include?('crn'), 'JSON response should include CRN field'
    assert body.include?('start_date'), 'JSON response should include start_date field'
    assert body.include?('end_date'), 'JSON response should include end_date field'
    assert body.include?('number'), 'JSON response should include number field'
    assert body.include?('title'), 'JSON response should include title field'
    assert body.include?('instructor_id'), 'JSON response should include instructor_id field'
    assert body.include?('instructor_first'), 'JSON response should include instructor_first field'
    assert body.include?('instructor_middle'), 'JSON response should include instructor_middle field'
    assert body.include?('instructor_last'), 'JSON response should include instructor_last field'
    assert body.include?('department_code'), 'JSON response should include department_code field'
    assert body.include?('department_description'), 'JSON response should include department_description field'
  end
  
end
