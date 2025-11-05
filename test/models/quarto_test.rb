require "test_helper"

class QuartoTest < ActiveSupport::TestCase
  test "fixture quartos are valid" do
    assert quartos(:downtown_101).valid?
    assert quartos(:seaside_201).valid?
  end

  test "full_label returns combined identification" do
    quarto = quartos(:downtown_101)

  assert_equal "101 - Suite Master - Hotel Downtown", quarto.full_label
  end

  test "status must be one of the defined values" do
    quarto = quartos(:downtown_101)
    assert_raise ArgumentError do
      quarto.status = "limpeza"
    end
  end

  test "invalid without price" do
    quarto = Quarto.new(hotel: hotels(:downtown), room_type: room_types(:suite_master), numero: "999", capacidade: 1, status: "disponivel")
    quarto.price_cents = -5

    refute quarto.valid?
    assert_includes quarto.errors[:price_cents], "must be greater than or equal to 0"
  end
end
