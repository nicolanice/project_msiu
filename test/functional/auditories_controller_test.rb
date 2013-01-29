require 'test_helper'

class AuditoriesControllerTest < ActionController::TestCase
  setup do
    @auditory = auditories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:auditories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create auditory" do
    assert_difference('Auditory.count') do
      post :create, :auditory => @auditory.attributes
    end

    assert_redirected_to auditory_path(assigns(:auditory))
  end

  test "should show auditory" do
    get :show, :id => @auditory.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @auditory.to_param
    assert_response :success
  end

  test "should update auditory" do
    put :update, :id => @auditory.to_param, :auditory => @auditory.attributes
    assert_redirected_to auditory_path(assigns(:auditory))
  end

  test "should destroy auditory" do
    assert_difference('Auditory.count', -1) do
      delete :destroy, :id => @auditory.to_param
    end

    assert_redirected_to auditories_path
  end
end
