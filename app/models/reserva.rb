class Reserva < ApplicationRecord
  belongs_to :hotel
  belongs_to :hospede

  validates :data_checkin, presence: true
  validates :data_checkout, presence: true, comparison: { greater_than: :data_checkin }
  validates :status, presence: true
  validates :valor_total, presence: true, numericality: { greater_than: 0 }
end
