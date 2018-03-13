require 'test_helper'

class WebserverControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get helper" do
    get :helper
    assert_response :success
  end

  test "should get video" do
    get :video
    assert_response :success
  end

end
