class Hospede < ApplicationRecord
    has_many :reservas 

    validates :nome, presence: true 
    validates :documento, presence: true, uniqueness: true
    validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}, uniqueness:true 
    validates :telefone, presence: true 
end
