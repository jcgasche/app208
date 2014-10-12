require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  test "should get fill_db" do
    get :fill_db
    assert_response :success
  end

end
