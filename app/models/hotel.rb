class Hotel < ApplicationRecord
    has_many :reservas 

    validates :nome, presence: true
    validates :cidade, presence: true 
    validates :endereco, presence: true 
    validates :telefone, presence: true 
    validates :categoria, presence: true 
end
