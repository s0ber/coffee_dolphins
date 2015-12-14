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

ActiveRecord::Schema.define(version: 20151214151701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmakers", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image"
    t.integer  "currency",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "description"
    t.string   "html_title"
    t.string   "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "landing_images", force: true do |t|
    t.string   "image"
    t.string   "alt_text",    default: ""
    t.integer  "position"
    t.boolean  "for_gallery", default: false
    t.integer  "landing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "landing_images", ["landing_id"], name: "index_landing_images_on_landing_id", using: :btree

  create_table "landings", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.decimal  "price"
    t.string   "video_id"
    t.integer  "color",               limit: 2, default: 0
    t.string   "apishops_article_id"
    t.string   "meta_description"
    t.string   "html_title"
    t.integer  "category_id"
    t.string   "_status"
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "short_description"
    t.string   "description_title"
    t.text     "description_text"
    t.string   "advantages_title"
    t.text     "advantages_text"
    t.string   "why_question"
    t.string   "reviews_title"
    t.string   "footer_title"
    t.integer  "apishops_site_id"
    t.integer  "discount",                      default: 30
    t.string   "reviews_footer"
    t.string   "subheader_title"
    t.integer  "template",                      default: 0
  end

  add_index "landings", ["category_id"], name: "index_landings_on_category_id", using: :btree
  add_index "landings", ["position_id"], name: "index_landings_on_position_id", using: :btree

  create_table "notes", force: true do |t|
    t.string   "title"
    t.text     "comment"
    t.integer  "notable_id"
    t.string   "notable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["notable_id", "notable_type"], name: "index_notes_on_notable_id_and_notable_type", using: :btree

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

  create_table "reviews", force: true do |t|
    t.string   "author"
    t.boolean  "author_gender",     default: true
    t.text     "text"
    t.integer  "landing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author_profession"
  end

  add_index "reviews", ["landing_id"], name: "index_reviews_on_landing_id", using: :btree

  create_table "search_keywords", force: true do |t|
    t.string   "name"
    t.integer  "search_count", default: 0
    t.integer  "position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_keywords", ["position_id"], name: "index_search_keywords_on_position_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                                       null: false
    t.string   "crypted_password",                            null: false
    t.string   "salt",                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "full_name"
    t.text     "description"
    t.boolean  "gender",                       default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree

end
