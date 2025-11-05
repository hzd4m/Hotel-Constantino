class CreateRoomTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :room_types do |t|
      t.references :hotel, null: false, foreign_key: true
      t.string :nome, null: false
      t.text :descricao
      t.integer :price_cents, null: false, default: 0
      t.text :amenities

      t.timestamps
    end

    add_index :room_types, [:hotel_id, :nome], unique: true
  end
end
