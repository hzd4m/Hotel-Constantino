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

ActiveRecord::Schema[8.0].define(version: 2025_10_16_223828) do
  create_table "hospedes", force: :cascade do |t|
    t.string "nome"
    t.string "documento"
    t.string "email"
    t.string "telefone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["documento"], name: "index_hospedes_on_documento", unique: true
    t.index ["email"], name: "index_hospedes_on_email", unique: true
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

  create_table "reservas", force: :cascade do |t|
    t.date "data_checkin"
    t.date "data_checkout"
    t.string "status"
    t.decimal "valor_total", precision: 10, scale: 2
    t.integer "hotel_id", null: false
    t.integer "hospede_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hospede_id"], name: "index_reservas_on_hospede_id"
    t.index ["hotel_id", "hospede_id"], name: "index_reservas_on_hotel_id_and_hospede_id"
    t.index ["hotel_id"], name: "index_reservas_on_hotel_id"
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

  add_foreign_key "reservas", "hospedes"
  add_foreign_key "reservas", "hotels"
end
