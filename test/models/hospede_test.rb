require "test_helper"

class HospedeTest < ActiveSupport::TestCase
  test "phone_verified? reflects verification timestamp" do
    assert hospedes(:verified).phone_verified?
    refute hospedes(:pending).phone_verified?
  end

  test "verify_phone! marks phone as verified when demo code matches" do
    hospede = hospedes(:pending)
    reserva = reservas(:pending_confirmation)

    assert_difference -> { reserva.reservation_events.count }, +1 do
      assert hospede.verify_phone!("0000"), "Expected verify_phone! to succeed with demo code"
    end

    assert hospede.reload.phone_verified?
  end
end
