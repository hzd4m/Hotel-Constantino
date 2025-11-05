require "test_helper"

class RoomTypeTest < ActiveSupport::TestCase
  test "fixture room types are valid" do
    assert room_types(:suite_master).valid?
    assert room_types(:ocean_deluxe).valid?
  end

  test "amenities_list removes blank entries" do
    room_type = room_types(:suite_master)
    room_type.amenities = ["Wi-Fi", "", "Cafe"]

    assert_equal ["Wi-Fi", "Cafe"], room_type.amenities_list
  end

  test "requires nome" do
    room_type = RoomType.new(hotel: hotels(:downtown), price_cents: 1000)

    refute room_type.valid?
    assert_includes room_type.errors[:nome], "can't be blank"
  end
end
