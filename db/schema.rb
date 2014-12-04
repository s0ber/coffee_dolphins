# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141204094701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "positions", force: true do |t|
    t.string   "title"
    t.string   "category"
    t.decimal  "price"
    t.decimal  "profit"
    t.integer  "availability_level"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "apishops_position_id"
    t.integer  "apishops_category_id"
    t.boolean  "liked",                default: false
  end

  create_table "search_keywords", force: true do |t|
    t.string   "name"
    t.integer  "search_count", default: 0
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_keywords", ["position_id"], name: "index_search_keywords_on_position_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                        null: false
    t.string   "crypted_password",             null: false
    t.string   "salt",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "full_name"
    t.text     "description"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree

end
