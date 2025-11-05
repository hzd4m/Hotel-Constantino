class Quarto < ApplicationRecord
  belongs_to :hotel
  belongs_to :room_type
  has_many :reservation_rooms, dependent: :destroy
  has_many :reservas, through: :reservation_rooms

  STATUSES = {
    disponivel: "disponivel",
    manutencao: "manutencao",
    ocupado: "ocupado"
  }.freeze unless const_defined?(:STATUSES)

  enum :status, STATUSES

  validates :numero, presence: true
  validates :capacidade, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: STATUSES.values }
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  scope :ativos, -> { where.not(status: STATUSES[:manutencao]) }

  def status_label
    I18n.t("quartos.status.#{status}", default: status.to_s.humanize)
  end

  def full_label
    [numero, room_type&.nome, hotel&.nome].compact.join(" - ")
  end
end
