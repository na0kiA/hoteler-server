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

ActiveRecord::Schema[7.0].define(version: 2022_12_17_100212) do
  create_table "days", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "hotel_id", null: false
    t.string "day", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_days_on_hotel_id"
  end

  create_table "favorites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "hotel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_favorites_on_hotel_id"
    t.index ["user_id", "hotel_id"], name: "index_favorites_on_user_id_and_hotel_id", unique: true
  end

  create_table "helpfulnesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "review_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id", "user_id"], name: "index_helpfulnesses_on_review_id_and_user_id", unique: true
    t.index ["review_id"], name: "index_helpfulnesses_on_review_id"
    t.index ["user_id"], name: "index_helpfulnesses_on_user_id"
  end

  create_table "hotel_facilities", primary_key: "hotel_id", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "parking_enabled", default: false, null: false
    t.boolean "triple_rooms_enabled", default: false, null: false
    t.boolean "secret_payment_enabled", default: false, null: false
    t.boolean "credit_card_enabled", default: false, null: false
    t.boolean "phone_reservation_enabled", default: false, null: false
    t.boolean "net_reservation_enabled", default: false, null: false
    t.boolean "cooking_enabled", default: false, null: false
    t.boolean "breakfast_enabled", default: false, null: false
    t.boolean "wifi_enabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "coupon_enabled", default: false
    t.index ["hotel_id"], name: "index_hotel_facilities_on_hotel_id"
  end

  create_table "hotel_images", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "hotel_id"
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_hotel_images_on_hotel_id"
    t.index ["key"], name: "index_hotel_images_on_key_and_file_url", unique: true
  end

  create_table "hotels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.text "content", null: false
    t.string "image"
    t.boolean "accepted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reviews_count", default: 0, null: false
    t.decimal "average_rating", precision: 2, scale: 1, default: "0.0", null: false
    t.integer "favorites_count", default: 0, null: false
    t.boolean "full", default: false, null: false
    t.string "prefecture", default: "", null: false
    t.string "city", default: "", null: false
    t.string "postal_code", default: "", null: false
    t.string "street_address", default: "", null: false
    t.string "phone_number", default: "", null: false
    t.string "company", default: "", null: false
    t.index ["city", "street_address"], name: "index_hotels_on_city_and_street_address"
    t.index ["user_id"], name: "index_hotels_on_user_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "kind", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "sender_id", null: false
    t.bigint "hotel_id"
    t.string "message", default: "", null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_notifications_on_hotel_id"
    t.index ["sender_id"], name: "index_notifications_on_sender_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "rest_rates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "day_id", null: false
    t.string "plan", default: "", null: false
    t.integer "rate", default: 0, null: false
    t.time "start_time", default: "2000-01-01 00:00:00", null: false
    t.time "end_time", default: "2000-01-01 00:00:00", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_rest_rates_on_day_id"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "hotel_id"
    t.string "title", null: false
    t.text "content", null: false
    t.integer "helpfulnesses_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "five_star_rate", default: 0
    t.index ["hotel_id"], name: "index_reviews_on_hotel_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "special_periods", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "day_id", null: false
    t.integer "period", default: 0, null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_special_periods_on_day_id"
  end

  create_table "stay_rates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "day_id", null: false
    t.string "plan", default: "", null: false
    t.integer "rate", default: 0, null: false
    t.time "start_time", default: "2000-01-01 00:00:00", null: false
    t.time "end_time", default: "2000-01-01 00:00:00", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_stay_rates_on_day_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "days", "hotels"
  add_foreign_key "favorites", "hotels"
  add_foreign_key "favorites", "users"
  add_foreign_key "helpfulnesses", "reviews"
  add_foreign_key "helpfulnesses", "users"
  add_foreign_key "hotel_facilities", "hotels"
  add_foreign_key "hotel_images", "hotels"
  add_foreign_key "hotels", "users"
  add_foreign_key "notifications", "hotels"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "sender_id"
  add_foreign_key "rest_rates", "days"
  add_foreign_key "reviews", "hotels"
  add_foreign_key "reviews", "users"
  add_foreign_key "special_periods", "days"
  add_foreign_key "stay_rates", "days"
end
