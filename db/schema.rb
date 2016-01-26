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

ActiveRecord::Schema.define(version: 20151216150342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bet_lines", force: :cascade do |t|
    t.datetime "performed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bets", force: :cascade do |t|
    t.integer  "fork_id"
    t.integer  "bookmaker_id"
    t.decimal  "ammount_rub"
    t.decimal  "prize"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "outcome",      limit: 255
  end

  add_index "bets", ["bookmaker_id"], name: "index_bets_on_bookmaker_id", using: :btree
  add_index "bets", ["fork_id"], name: "index_bets_on_fork_id", using: :btree

  create_table "bookmakers", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.text     "description"
    t.string   "image",          limit: 255
    t.integer  "currency",                   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "statistics_url", limit: 255
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "slug",             limit: 255
    t.text     "description"
    t.string   "html_title",       limit: 255
    t.string   "meta_description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forks", force: :cascade do |t|
    t.integer  "bet_line_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",              limit: 255
    t.integer  "winning_bet_id"
    t.datetime "played_out_at"
    t.datetime "event_scheduled_at"
  end

  add_index "forks", ["bet_line_id"], name: "index_forks_on_bet_line_id", using: :btree

  create_table "landing_images", force: :cascade do |t|
    t.string   "image",       limit: 255
    t.string   "alt_text",    limit: 255, default: ""
    t.integer  "position"
    t.boolean  "for_gallery",             default: false
    t.integer  "landing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "landing_images", ["landing_id"], name: "index_landing_images_on_landing_id", using: :btree

  create_table "landings", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.string   "slug",                limit: 255
    t.decimal  "price"
    t.string   "video_id",            limit: 255
    t.integer  "color",               limit: 2,   default: 0
    t.string   "apishops_article_id", limit: 255
    t.string   "meta_description",    limit: 255
    t.string   "html_title",          limit: 255
    t.integer  "category_id"
    t.string   "_status",             limit: 255
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "short_description"
    t.string   "description_title",   limit: 255
    t.text     "description_text"
    t.string   "advantages_title",    limit: 255
    t.text     "advantages_text"
    t.string   "why_question",        limit: 255
    t.string   "reviews_title",       limit: 255
    t.string   "footer_title",        limit: 255
    t.integer  "apishops_site_id"
    t.integer  "discount",                        default: 30
    t.string   "reviews_footer",      limit: 255
    t.string   "subheader_title",     limit: 255
    t.integer  "template",                        default: 0
  end

  add_index "landings", ["category_id"], name: "index_landings_on_category_id", using: :btree
  add_index "landings", ["position_id"], name: "index_landings_on_position_id", using: :btree

  create_table "notes", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "comment"
    t.integer  "notable_id"
    t.string   "notable_type", limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["notable_id", "notable_type"], name: "index_notes_on_notable_id_and_notable_type", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.string   "category",             limit: 255
    t.decimal  "price"
    t.decimal  "profit"
    t.integer  "availability_level"
    t.string   "image_url",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "apishops_position_id"
    t.integer  "apishops_category_id"
    t.boolean  "liked",                            default: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "author",            limit: 255
    t.boolean  "author_gender",                 default: true
    t.text     "text"
    t.integer  "landing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author_profession", limit: 255
  end

  add_index "reviews", ["landing_id"], name: "index_reviews_on_landing_id", using: :btree

  create_table "search_keywords", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "search_count",             default: 0
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_keywords", ["position_id"], name: "index_search_keywords_on_position_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.decimal  "ammount_rub"
    t.decimal  "ammount"
    t.integer  "currency"
    t.integer  "bookmaker_id"
    t.datetime "performed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kind",         default: 0
    t.integer  "bet_id"
  end

  add_index "transactions", ["bet_id"], name: "index_transactions_on_bet_id", using: :btree
  add_index "transactions", ["bookmaker_id"], name: "index_transactions_on_bookmaker_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                        limit: 255,                null: false
    t.string   "crypted_password",             limit: 255,                null: false
    t.string   "salt",                         limit: 255,                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token",            limit: 255
    t.datetime "remember_me_token_expires_at"
    t.string   "full_name",                    limit: 255
    t.text     "description"
    t.boolean  "gender",                                   default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree

end
