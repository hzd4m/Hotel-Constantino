require "test_helper"

class HotelTest < ActiveSupport::TestCase
  test "fixture hotels are valid" do
    assert hotels(:downtown).valid?
    assert hotels(:seaside).valid?
  end

  test "available_quartos returns rooms flagged as available" do
    hotel = hotels(:downtown)

    assert_includes hotel.available_quartos, quartos(:downtown_101)
    refute_includes hotel.available_quartos, quartos(:downtown_102)
  end
end
