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

ActiveRecord::Schema.define(version: 2020_04_28_003345) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "collections", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "contents_count", default: 0
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug"
    t.jsonb "metadata", default: {}, null: false
    t.uuid "key"
    t.index ["key"], name: "index_collections_on_key", unique: true
    t.index ["slug"], name: "index_collections_on_slug"
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "contents", id: :serial, force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position"
    t.string "entity_type"
    t.bigint "entity_id"
    t.jsonb "metadata", default: {}, null: false
    t.index ["collection_id"], name: "index_contents_on_collection_id"
    t.index ["entity_type", "entity_id"], name: "index_contents_on_entity_type_and_entity_id"
    t.index ["user_id"], name: "index_contents_on_user_id"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.text "url"
    t.text "source_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.integer "width"
    t.integer "height"
    t.index ["url"], name: "index_images_on_url", unique: true
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.text "url"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "texts", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_texts_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "username", null: false
    t.string "crypted_password", null: false
    t.string "salt", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string "slug"
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "links", "users"
  add_foreign_key "texts", "users"
end
