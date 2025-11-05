class RoomType < ApplicationRecord
  belongs_to :hotel
  has_many :quartos, dependent: :restrict_with_exception

  # Use JSON coder for serialized array to be compatible with Rails 8+.
  serialize :amenities, coder: JSON

  validates :nome, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  def amenities_list
    Array(amenities).reject(&:blank?)
  end
end
