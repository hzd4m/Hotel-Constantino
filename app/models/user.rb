class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { hospede: 0, admin: 1 }

  def hospede_record
    @hospede_record ||= Hospede.find_by(email: email)
  end
end
