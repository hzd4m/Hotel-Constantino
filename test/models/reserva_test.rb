require "test_helper"

class ReservaTest < ActiveSupport::TestCase
  test "fixture reservations are valid" do
    assert reservas(:upcoming).valid?
    assert reservas(:pending_confirmation).valid?
    assert reservas(:in_progress).valid?
  end

  test "assigned_quartos_label lists associated rooms" do
    reserva = reservas(:upcoming)

    assert_includes reserva.assigned_quartos_label, "101"
    assert_includes reserva.assigned_quartos_label, "Suite Master"
  end

  test "can_be_confirmed? requires verified phone" do
    assert reservas(:upcoming).can_be_confirmed?, "Verified guest should allow confirmation"
    refute reservas(:pending_confirmation).can_be_confirmed?, "Unverified guest should block confirmation"
  end

  test "mark_confirmed_by! updates status and audit trail" do
    reserva = reservas(:upcoming)
    user = users(:admin)

    assert_difference "ReservationEvent.count", +1 do
      assert reserva.mark_confirmed_by!(user)
    end

    reserva.reload
    assert reserva.confirmada?
    assert_equal user, reserva.confirmed_by
    assert reserva.confirmed_at.present?
  end
end
