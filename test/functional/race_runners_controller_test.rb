require 'test_helper'

class RaceRunnersControllerTest < ActionController::TestCase
  setup do
    @race_runner = race_runners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:race_runners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create race_runner" do
    assert_difference('RaceRunner.count') do
      post :create, :race_runner => { :nationality => @race_runner.nationality, :number => @race_runner.number, :team => @race_runner.team }
    end

    assert_redirected_to race_runner_path(assigns(:race_runner))
  end

  test "should show race_runner" do
    get :show, :id => @race_runner
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @race_runner
    assert_response :success
  end

  test "should update race_runner" do
    put :update, :id => @race_runner, :race_runner => { :nationality => @race_runner.nationality, :number => @race_runner.number, :team => @race_runner.team }
    assert_redirected_to race_runner_path(assigns(:race_runner))
  end

  test "should destroy race_runner" do
    assert_difference('RaceRunner.count', -1) do
      delete :destroy, :id => @race_runner
    end

    assert_redirected_to race_runners_path
  end
end
