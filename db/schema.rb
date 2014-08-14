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

ActiveRecord::Schema.define(version: 20140810022051) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collections", force: true do |t|
    t.string   "title"
    t.integer  "connections_count", default: 0
    t.integer  "user_id",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["user_id"], name: "index_collections_on_user_id", using: :btree

  create_table "connections", force: true do |t|
    t.integer  "collection_id", null: false
    t.integer  "image_id",      null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connections", ["collection_id"], name: "index_connections_on_collection_id", using: :btree
  add_index "connections", ["image_id"], name: "index_connections_on_image_id", using: :btree
  add_index "connections", ["user_id"], name: "index_connections_on_user_id", using: :btree

  create_table "images", force: true do |t|
    t.text     "url"
    t.text     "source_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                           null: false
    t.string   "username",                        null: false
    t.string   "crypted_password",                null: false
    t.string   "salt",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
