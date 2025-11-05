require "test_helper"

class ReservationRoomTest < ActiveSupport::TestCase
  test "fixture reservation room is valid" do
    assert reservation_rooms(:upcoming_room).valid?
  end

  test "cannot assign the same quarto twice to the same reserva" do
    duplicate = ReservationRoom.new(reserva: reservas(:upcoming), quarto: quartos(:downtown_101))

    refute duplicate.valid?
    assert_includes duplicate.errors[:reserva_id], "has already been taken"
  end
end
