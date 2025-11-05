class AddConfirmationTrackingToReservas < ActiveRecord::Migration[8.0]
  def change
    add_column :reservas, :confirmed_at, :datetime
    add_reference :reservas, :confirmed_by, foreign_key: { to_table: :users }, index: true
  end
end
