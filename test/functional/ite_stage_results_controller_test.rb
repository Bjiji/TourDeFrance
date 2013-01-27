require 'test_helper'

class IteStageResultsControllerTest < ActionController::TestCase
  setup do
    @ite_stage_result = ite_stage_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ite_stage_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ite_stage_result" do
    assert_difference('IteStageResult.count') do
      post :create, :ite_stage_result => { :diff_time_sec => @ite_stage_result.diff_time, :dnf => @ite_stage_result.dnf, :dnq => @ite_stage_result.dnq, :dns => @ite_stage_result.dns, :pos => @ite_stage_result.pos, :time => @ite_stage_result.time }
    end

    assert_redirected_to ite_stage_result_path(assigns(:ite_stage_result))
  end

  test "should show ite_stage_result" do
    get :show, :id => @ite_stage_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ite_stage_result
    assert_response :success
  end

  test "should update ite_stage_result" do
    put :update, :id => @ite_stage_result, :ite_stage_result => { :diff_time => @ite_stage_result.diff_time, :dnf => @ite_stage_result.dnf, :dnq => @ite_stage_result.dnq, :dns => @ite_stage_result.dns, :pos => @ite_stage_result.pos, :time => @ite_stage_result.time }
    assert_redirected_to ite_stage_result_path(assigns(:ite_stage_result))
  end

  test "should destroy ite_stage_result" do
    assert_difference('IteStageResult.count', -1) do
      delete :destroy, :id => @ite_stage_result
    end

    assert_redirected_to ite_stage_results_path
  end
end
