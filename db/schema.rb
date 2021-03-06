# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_06_12_021321) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chatrooms", force: :cascade do |t|
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_chatrooms_on_group_id"
  end

  create_table "chats", force: :cascade do |t|
    t.text "message"
    t.bigint "chatroom_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_chats_on_chatroom_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.text "description"
    t.integer "portfolio_value_cents", default: 0, null: false
    t.integer "cash_value_cents", default: 0, null: false
    t.integer "investment_value_cents", default: 0, null: false
    t.integer "total_shares", default: 0
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "watchlist", default: ["AAPL", "GE", "F", "MSFT", "AMD", "FIT", "GPRO", "FB", "TWTR", "NFLX"], array: true
    t.text "performance"
    t.index ["creator_id"], name: "index_groups_on_creator_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "price_cents"
    t.integer "quantity"
    t.string "ticker"
    t.boolean "buy"
    t.bigint "poll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "filled", default: false
    t.index ["poll_id"], name: "index_orders_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.text "description"
    t.float "approval", default: 0.0, null: false
    t.integer "target_price_cents"
    t.integer "stop_loss_price_cents"
    t.boolean "buy"
    t.integer "quantity"
    t.integer "price_cents"
    t.datetime "expiration"
    t.string "ticker"
    t.bigint "group_id"
    t.bigint "creator_id"
    t.bigint "position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_polls_on_creator_id"
    t.index ["group_id"], name: "index_polls_on_group_id"
    t.index ["position_id"], name: "index_polls_on_position_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "ticker"
    t.integer "quantity", default: 0, null: false
    t.integer "cost_basis_cents"
    t.integer "current_price_cents"
    t.integer "return_cents"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_positions_on_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.integer "user_contribution_cents", default: 0, null: false
    t.integer "user_share", default: 0, null: false
    t.integer "user_balance_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.boolean "is_female", default: false
    t.string "photo"
    t.integer "total_balance_cents", default: 0, null: false
    t.integer "available_balance_cents", default: 0, null: false
    t.string "address"
    t.string "google_token"
    t.string "google_refresh_token"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.float "voting_power"
    t.boolean "approve"
    t.bigint "user_id"
    t.bigint "poll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_votes_on_poll_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "chatrooms", "groups"
  add_foreign_key "chats", "chatrooms"
  add_foreign_key "chats", "users"
  add_foreign_key "groups", "users", column: "creator_id"
  add_foreign_key "orders", "polls"
  add_foreign_key "polls", "groups"
  add_foreign_key "polls", "positions"
  add_foreign_key "polls", "users", column: "creator_id"
  add_foreign_key "positions", "groups"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "votes", "polls"
  add_foreign_key "votes", "users"
end
