require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get main" do
    get :main
    assert_response :success
  end

end
