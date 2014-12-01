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

ActiveRecord::Schema.define(version: 20141124113002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "feed_items", force: true do |t|
    t.integer  "podcast_id"
    t.string   "title"
    t.text     "summary"
    t.string   "url"
    t.string   "entry_id"
    t.string   "image"
    t.datetime "published_at"
    t.boolean  "listened",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_items", ["entry_id"], name: "index_feed_items_on_entry_id", unique: true, using: :btree
  add_index "feed_items", ["podcast_id"], name: "index_feed_items_on_podcast_id", using: :btree

  create_table "podcasts", force: true do |t|
    t.string   "title"
    t.text     "sub_title"
    t.string   "url"
    t.string   "itunes_image"
    t.text     "description"
    t.string   "author"
    t.string   "owners_email"
    t.string   "atom_link"
    t.text     "keywords"
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "podcasts", ["category_id"], name: "index_podcasts_on_category_id", using: :btree
  add_index "podcasts", ["user_id"], name: "index_podcasts_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "profile_image_url"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
