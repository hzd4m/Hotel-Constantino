# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_05_040400) do
  create_table "consumptions", force: :cascade do |t|
    t.integer "reserva_id", null: false
    t.string "title", null: false
    t.text "notes"
    t.string "status", default: "solicitado", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "requested_by", default: "staff", null: false
    t.datetime "requested_at", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reserva_id"], name: "index_consumptions_on_reserva_id"
    t.index ["status"], name: "index_consumptions_on_status"
  end

  create_table "hospedes", force: :cascade do |t|
    t.string "nome"
    t.string "documento"
    t.string "email"
    t.string "telefone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_verification_code"
    t.datetime "phone_verification_sent_at"
    t.datetime "phone_verified_at"
    t.index ["documento"], name: "index_hospedes_on_documento", unique: true
    t.index ["email"], name: "index_hospedes_on_email", unique: true
    t.index ["phone_verification_code"], name: "index_hospedes_on_phone_verification_code"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "nome"
    t.string "cidade"
    t.string "endereco"
    t.string "telefone"
    t.string "categoria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cidade"], name: "index_hotels_on_cidade"
    t.index ["nome"], name: "index_hotels_on_nome"
  end

  create_table "quartos", force: :cascade do |t|
    t.integer "hotel_id", null: false
    t.integer "room_type_id", null: false
    t.string "numero", null: false
    t.string "andar"
    t.integer "capacidade", default: 1, null: false
    t.text "descricao"
    t.string "status", default: "disponivel", null: false
    t.integer "price_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id", "numero"], name: "index_quartos_on_hotel_id_and_numero", unique: true
    t.index ["hotel_id"], name: "index_quartos_on_hotel_id"
    t.index ["room_type_id"], name: "index_quartos_on_room_type_id"
    t.index ["status"], name: "index_quartos_on_status"
  end

  create_table "reservas", force: :cascade do |t|
    t.date "data_checkin"
    t.date "data_checkout"
    t.string "status", default: "aguardando_confirmacao", null: false
    t.decimal "valor_total", precision: 10, scale: 2
    t.integer "hotel_id", null: false
    t.integer "hospede_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.integer "confirmed_by_id"
    t.datetime "check_in_at"
    t.datetime "check_out_at"
    t.string "kiosk_token"
    t.index ["confirmed_by_id"], name: "index_reservas_on_confirmed_by_id"
    t.index ["hospede_id"], name: "index_reservas_on_hospede_id"
    t.index ["hotel_id", "hospede_id"], name: "index_reservas_on_hotel_id_and_hospede_id"
    t.index ["hotel_id"], name: "index_reservas_on_hotel_id"
    t.index ["kiosk_token"], name: "index_reservas_on_kiosk_token", unique: true
  end

  create_table "reservation_events", force: :cascade do |t|
    t.integer "reserva_id", null: false
    t.string "event_type", null: false
    t.json "metadata", default: {}
    t.integer "performed_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type"], name: "index_reservation_events_on_event_type"
    t.index ["performed_by_id"], name: "index_reservation_events_on_performed_by_id"
    t.index ["reserva_id"], name: "index_reservation_events_on_reserva_id"
  end

  create_table "reservation_rooms", force: :cascade do |t|
    t.integer "reserva_id", null: false
    t.integer "quarto_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quarto_id"], name: "index_reservation_rooms_on_quarto_id"
    t.index ["reserva_id", "quarto_id"], name: "index_reservation_rooms_on_reserva_id_and_quarto_id", unique: true
    t.index ["reserva_id"], name: "index_reservation_rooms_on_reserva_id"
  end

  create_table "room_types", force: :cascade do |t|
    t.integer "hotel_id", null: false
    t.string "nome", null: false
    t.text "descricao"
    t.integer "price_cents", default: 0, null: false
    t.text "amenities"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id", "nome"], name: "index_room_types_on_hotel_id_and_nome", unique: true
    t.index ["hotel_id"], name: "index_room_types_on_hotel_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "consumptions", "reservas"
  add_foreign_key "quartos", "hotels"
  add_foreign_key "quartos", "room_types"
  add_foreign_key "reservas", "hospedes"
  add_foreign_key "reservas", "hotels"
  add_foreign_key "reservas", "users", column: "confirmed_by_id"
  add_foreign_key "reservation_events", "reservas"
  add_foreign_key "reservation_events", "users", column: "performed_by_id"
  add_foreign_key "reservation_rooms", "quartos"
  add_foreign_key "reservation_rooms", "reservas"
  add_foreign_key "room_types", "hotels"
end
