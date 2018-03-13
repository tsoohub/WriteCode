require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

  test "should get chapter" do
    get :chapter
    assert_response :success
  end

  test "should get glossary" do
    get :glossary
    assert_response :success
  end

end
