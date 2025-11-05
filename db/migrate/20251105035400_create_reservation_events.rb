class CreateReservationEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :reservation_events do |t|
      t.references :reserva, null: false, foreign_key: true
      t.string :event_type, null: false
      t.json :metadata, default: {}
      t.references :performed_by, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :reservation_events, :event_type
  end
end
