require 'test_helper'

class AcademicTitlesControllerTest < ActionController::TestCase
  setup do
    @academic_title = academic_titles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:academic_titles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create academic_title" do
    assert_difference('AcademicTitle.count') do
      post :create, :academic_title => @academic_title.attributes
    end

    assert_redirected_to academic_title_path(assigns(:academic_title))
  end

  test "should show academic_title" do
    get :show, :id => @academic_title.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @academic_title.to_param
    assert_response :success
  end

  test "should update academic_title" do
    put :update, :id => @academic_title.to_param, :academic_title => @academic_title.attributes
    assert_redirected_to academic_title_path(assigns(:academic_title))
  end

  test "should destroy academic_title" do
    assert_difference('AcademicTitle.count', -1) do
      delete :destroy, :id => @academic_title.to_param
    end

    assert_redirected_to academic_titles_path
  end
end
