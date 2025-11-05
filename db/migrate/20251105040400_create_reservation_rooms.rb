class CreateReservationRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :reservation_rooms do |t|
      t.references :reserva, null: false, foreign_key: true
      t.references :quarto, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reservation_rooms, [:reserva_id, :quarto_id], unique: true
  end
end
