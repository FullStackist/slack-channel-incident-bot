require "test_helper"

class Command::RootlyControllerTest < ActionDispatch::IntegrationTest
  test "should get handle_command" do
    get command_rootly_handle_command_url
    assert_response :success
  end
end
