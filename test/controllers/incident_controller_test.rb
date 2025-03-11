require "test_helper"

class IncidentControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get incident_list_url
    assert_response :success
  end
end
