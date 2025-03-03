require "application_system_test_case"

class ReservesTest < ApplicationSystemTestCase
  setup do
    @reserf = reserves(:one)
  end

  test "visiting the index" do
    visit reserves_url
    assert_selector "h1", text: "Reserves"
  end

  test "should create reserve" do
    visit reserves_url
    click_on "New reserve"

    fill_in "Date", with: @reserf.date
    fill_in "End timer", with: @reserf.end_timer
    fill_in "Note", with: @reserf.note
    fill_in "Start timer", with: @reserf.start_timer
    click_on "Create Reserve"

    assert_text "Reserve was successfully created"
    click_on "Back"
  end

  test "should update Reserve" do
    visit reserf_url(@reserf)
    click_on "Edit this reserve", match: :first

    fill_in "Date", with: @reserf.date
    fill_in "End timer", with: @reserf.end_timer
    fill_in "Note", with: @reserf.note
    fill_in "Start timer", with: @reserf.start_timer
    click_on "Update Reserve"

    assert_text "Reserve was successfully updated"
    click_on "Back"
  end

  test "should destroy Reserve" do
    visit reserf_url(@reserf)
    click_on "Destroy this reserve", match: :first

    assert_text "Reserve was successfully destroyed"
  end
end
