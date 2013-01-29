require 'test_helper'

class ProtocolTemplatesControllerTest < ActionController::TestCase
  setup do
    @protocol_template = protocol_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:protocol_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create protocol_template" do
    assert_difference('ProtocolTemplate.count') do
      post :create, :protocol_template => @protocol_template.attributes
    end

    assert_redirected_to protocol_template_path(assigns(:protocol_template))
  end

  test "should show protocol_template" do
    get :show, :id => @protocol_template.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @protocol_template.to_param
    assert_response :success
  end

  test "should update protocol_template" do
    put :update, :id => @protocol_template.to_param, :protocol_template => @protocol_template.attributes
    assert_redirected_to protocol_template_path(assigns(:protocol_template))
  end

  test "should destroy protocol_template" do
    assert_difference('ProtocolTemplate.count', -1) do
      delete :destroy, :id => @protocol_template.to_param
    end

    assert_redirected_to protocol_templates_path
  end
end
