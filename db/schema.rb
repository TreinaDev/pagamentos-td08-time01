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

ActiveRecord::Schema[7.0].define(version: 2022_06_20_135947) do
  create_table "admin_permissions", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "active_admin"
    t.index ["admin_id"], name: "index_admin_permissions_on_admin_id"
  end

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
    t.integer "status", default: 0
    t.index ["cpf"], name: "index_admins_on_cpf", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "client_bonus_balances", force: :cascade do |t|
    t.float "bonus_value", default: 0.0
    t.date "expire_date"
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_bonus_balances_on_client_id"
  end

  create_table "client_categories", force: :cascade do |t|
    t.string "name"
    t.float "discount_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_client_categories_on_name", unique: true
  end

  create_table "client_companies", force: :cascade do |t|
    t.string "company_name"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id", null: false
    t.index ["client_id"], name: "index_client_companies_on_client_id"
    t.index ["cnpj"], name: "index_client_companies_on_cnpj", unique: true
  end

  create_table "client_people", force: :cascade do |t|
    t.string "full_name"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_id", null: false
    t.index ["client_id"], name: "index_client_people_on_client_id"
    t.index ["cpf"], name: "index_client_people_on_cpf", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.integer "client_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "client_category_id", null: false
    t.float "balance", default: 0.0
    t.index ["client_category_id"], name: "index_clients_on_client_category_id"
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
    t.integer "recused_by_id"
    t.float "variation", default: 0.0
    t.index ["approved_by_id"], name: "index_exchange_rates_on_approved_by_id"
    t.index ["created_by_id"], name: "index_exchange_rates_on_created_by_id"
    t.index ["recused_by_id"], name: "index_exchange_rates_on_recused_by_id"
    t.index ["register_date"], name: "index_exchange_rates_on_register_date", unique: true
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.float "bonus"
    t.integer "limit_day"
    t.integer "client_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_category_id"], name: "index_promotions_on_client_category_id"
    t.index ["start_date", "client_category_id"], name: "index_promotions_on_start_date_and_client_category_id", unique: true
  end

  create_table "transaction_settings", force: :cascade do |t|
    t.decimal "max_credit", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admin_permissions", "admins"
  add_foreign_key "client_bonus_balances", "clients"
  add_foreign_key "client_companies", "clients"
  add_foreign_key "client_people", "clients"
  add_foreign_key "clients", "client_categories"
  add_foreign_key "exchange_rates", "admins", column: "approved_by_id"
  add_foreign_key "exchange_rates", "admins", column: "created_by_id"
  add_foreign_key "exchange_rates", "admins", column: "recused_by_id"
  add_foreign_key "promotions", "client_categories"
end
