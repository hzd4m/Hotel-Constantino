class CreateConsumptions < ActiveRecord::Migration[8.0]
  def change
    create_table :consumptions do |t|
      t.references :reserva, null: false, foreign_key: true
      t.string :title, null: false
      t.text :notes
      t.string :status, null: false, default: "solicitado"
      t.decimal :amount, precision: 10, scale: 2
      t.string :requested_by, null: false, default: "staff"
      t.datetime :requested_at, null: false
      t.datetime :completed_at

      t.timestamps
    end

    add_index :consumptions, :status
  end
end
