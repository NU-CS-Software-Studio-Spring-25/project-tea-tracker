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

ActiveRecord::Schema[8.0].define(version: 2025_05_11_201808) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "entries", force: :cascade do |t|
    t.integer "rank"
    t.bigint "user_id", null: false
    t.bigint "tea_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0, null: false
    t.index ["position"], name: "index_entries_on_position"
    t.index ["tea_id"], name: "index_entries_on_tea_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "teas", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "vendor"
    t.string "known_for"
    t.string "region"
    t.integer "popularity"
    t.string "shopping_platform"
    t.string "product_url"
    t.string "price_mode"
    t.decimal "total_price", precision: 10, scale: 2
    t.decimal "weight", precision: 10, scale: 2
    t.integer "year"
    t.string "ship_from"
    t.integer "grams"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bio", limit: 500
    t.string "avatar_url", limit: 255
    t.string "password_digest"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "entries", "teas"
  add_foreign_key "entries", "users"
end
