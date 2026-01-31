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

ActiveRecord::Schema[8.1].define(version: 2026_01_31_111508) do
  create_table "books", force: :cascade do |t|
    t.string "author", null: false
    t.datetime "created_at", null: false
    t.date "published_at"
    t.string "publisher"
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reading_logs", force: :cascade do |t|
    t.integer "book_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["book_id"], name: "index_reading_logs_on_book_id"
    t.index ["user_id"], name: "index_reading_logs_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "reading_logs", "books"
  add_foreign_key "reading_logs", "users"
  add_foreign_key "sessions", "users"
end
