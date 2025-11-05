class CreateQuartos < ActiveRecord::Migration[8.0]
  def change
    create_table :quartos do |t|
      t.references :hotel, null: false, foreign_key: true
      t.references :room_type, null: false, foreign_key: true
      t.string :numero, null: false
      t.string :andar
      t.integer :capacidade, null: false, default: 1
      t.text :descricao
      t.string :status, null: false, default: "disponivel"
      t.integer :price_cents, null: false, default: 0

      t.timestamps
    end

    add_index :quartos, [:hotel_id, :numero], unique: true
    add_index :quartos, :status
  end
end
