class AddPhoneVerificationToHospedes < ActiveRecord::Migration[8.0]
  def change
    add_column :hospedes, :phone_verification_code, :string
    add_column :hospedes, :phone_verification_sent_at, :datetime
    add_column :hospedes, :phone_verified_at, :datetime
    add_index :hospedes, :phone_verification_code
  end
end
