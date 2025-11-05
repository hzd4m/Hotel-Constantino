class AddStayTrackingToReservas < ActiveRecord::Migration[8.0]
  def change
    add_column :reservas, :check_in_at, :datetime
    add_column :reservas, :check_out_at, :datetime
    add_column :reservas, :kiosk_token, :string

    add_index :reservas, :kiosk_token, unique: true
  end
end
