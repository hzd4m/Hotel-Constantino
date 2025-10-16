class CreateReservas < ActiveRecord::Migration[8.0]
  def change
    create_table :reservas do |t|
      t.date :data_checkin
      t.date :data_checkout
      t.string :status
      t.decimal :valor_total, precision: 10, scale: 2
      t.references :hotel, null: false, foreign_key: true
      t.references :hospede, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reservas, [:hotel_id, :hospede_id]
  end
end
