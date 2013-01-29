require 'test_helper'

class ParticipansControllerTest < ActionController::TestCase
  setup do
    @participan = participans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:participans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create participan" do
    assert_difference('Participan.count') do
      post :create, :participan => @participan.attributes
    end

    assert_redirected_to participan_path(assigns(:participan))
  end

  test "should show participan" do
    get :show, :id => @participan.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @participan.to_param
    assert_response :success
  end

  test "should update participan" do
    put :update, :id => @participan.to_param, :participan => @participan.attributes
    assert_redirected_to participan_path(assigns(:participan))
  end

  test "should destroy participan" do
    assert_difference('Participan.count', -1) do
      delete :destroy, :id => @participan.to_param
    end

    assert_redirected_to participans_path
  end
end
