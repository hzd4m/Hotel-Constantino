class Hotel < ApplicationRecord
    has_many :reservas
    has_many :quartos, dependent: :destroy
    has_many :room_types, dependent: :destroy

    validates :nome, presence: true
    validates :cidade, presence: true
    validates :endereco, presence: true
    validates :telefone, presence: true
    validates :categoria, presence: true

    def available_quartos
        quartos.disponivel
    end
end
