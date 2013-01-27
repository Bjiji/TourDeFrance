require 'test_helper'

class CyclistsControllerTest < ActionController::TestCase
  setup do
    @cyclist = cyclists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cyclists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cyclist" do
    assert_difference('Cyclist.count') do
      post :create, :cyclist => { :description => @cyclist.description, :dob => @cyclist.dob, :firstname => @cyclist.firstname, :lastname => @cyclist.lastname, :nationality => @cyclist.nationality, :pob => @cyclist.pob }
    end

    assert_redirected_to cyclist_path(assigns(:cyclist))
  end

  test "should show cyclist" do
    get :show, :id => @cyclist
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cyclist
    assert_response :success
  end

  test "should update cyclist" do
    put :update, :id => @cyclist, :cyclist => { :description => @cyclist.description, :dob => @cyclist.dob, :firstname => @cyclist.firstname, :lastname => @cyclist.lastname, :nationality => @cyclist.nationality, :pob => @cyclist.pob }
    assert_redirected_to cyclist_path(assigns(:cyclist))
  end

  test "should destroy cyclist" do
    assert_difference('Cyclist.count', -1) do
      delete :destroy, :id => @cyclist
    end

    assert_redirected_to cyclists_path
  end
end
