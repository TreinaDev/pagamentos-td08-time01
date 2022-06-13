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

ActiveRecord::Schema[7.0].define(version: 2022_06_13_170840) do
  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "full_name"
    t.string "cpf", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "client_categories", force: :cascade do |t|
    t.string "name"
    t.float "discount_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_people", force: :cascade do |t|
    t.string "full_name"
    t.string "cpf"
  end
  
  create_table "exchange_rates", force: :cascade do |t|
    t.integer "rubi_coin", default: 1
    t.float "brl_coin"
    t.date "register_date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by_id", null: false
    t.integer "approved_by_id"
    t.float "variation", default: 0.0
    t.integer "recused_by_id"
    t.index ["approved_by_id"], name: "index_exchange_rates_on_approved_by_id"
    t.index ["created_by_id"], name: "index_exchange_rates_on_created_by_id"
    t.index ["recused_by_id"], name: "index_exchange_rates_on_recused_by_id"
    t.index ["register_date"], name: "index_exchange_rates_on_register_date", unique: true
  end

  add_foreign_key "exchange_rates", "admins", column: "approved_by_id"
  add_foreign_key "exchange_rates", "admins", column: "created_by_id"
  add_foreign_key "exchange_rates", "admins", column: "recused_by_id"
end
