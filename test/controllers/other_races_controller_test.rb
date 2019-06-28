require 'test_helper'

class OtherRacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @other_race = other_races(:one)
  end

  test "should get index" do
    get other_races_url
    assert_response :success
  end

  test "should get new" do
    get new_other_race_url
    assert_response :success
  end

  test "should create other_race" do
    assert_difference('OtherRace.count') do
      post other_races_url, params: { other_race: { cyclist_id: @other_race.cyclist_id, race_label: @other_race.race_label, race_name: @other_race.race_name, year: @other_race.year } }
    end

    assert_redirected_to other_race_url(OtherRace.last)
  end

  test "should show other_race" do
    get other_race_url(@other_race)
    assert_response :success
  end

  test "should get edit" do
    get edit_other_race_url(@other_race)
    assert_response :success
  end

  test "should update other_race" do
    patch other_race_url(@other_race), params: { other_race: { cyclist_id: @other_race.cyclist_id, race_label: @other_race.race_label, race_name: @other_race.race_name, year: @other_race.year } }
    assert_redirected_to other_race_url(@other_race)
  end

  test "should destroy other_race" do
    assert_difference('OtherRace.count', -1) do
      delete other_race_url(@other_race)
    end

    assert_redirected_to other_races_url
  end
end
