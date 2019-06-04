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

ActiveRecord::Schema.define(version: 2019_06_03_102813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "photo"
    t.text "description"
    t.float "portfolio_value"
    t.float "cash_value"
    t.float "investment_value"
    t.integer "total_shares"
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_groups_on_creator_id"
  end

  create_table "orders", force: :cascade do |t|
    t.float "price"
    t.integer "quantity"
    t.string "ticker"
    t.boolean "buy"
    t.bigint "poll_id"
    t.bigint "position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_orders_on_poll_id"
    t.index ["position_id"], name: "index_orders_on_position_id"
  end

  create_table "polls", force: :cascade do |t|
    t.text "description"
    t.float "approval"
    t.float "target_price"
    t.float "stop_loss_price"
    t.boolean "buy"
    t.integer "quantity"
    t.float "price"
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
    t.integer "quantity"
    t.float "cost_basis"
    t.float "current_price"
    t.float "return"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_positions_on_group_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.float "user_contribution"
    t.integer "user_share"
    t.float "user_balance"
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

  add_foreign_key "groups", "users", column: "creator_id"
  add_foreign_key "orders", "polls"
  add_foreign_key "orders", "positions"
  add_foreign_key "polls", "groups"
  add_foreign_key "polls", "positions"
  add_foreign_key "polls", "users", column: "creator_id"
  add_foreign_key "positions", "groups"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "votes", "polls"
  add_foreign_key "votes", "users"
end
