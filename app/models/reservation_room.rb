class ReservationRoom < ApplicationRecord
  belongs_to :reserva
  belongs_to :quarto

  validates :reserva_id, uniqueness: { scope: :quarto_id }
end
