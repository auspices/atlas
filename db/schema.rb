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

ActiveRecord::Schema[7.1].define(version: 2025_02_09_173724) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "attachments", force: :cascade do |t|
    t.text "url"
    t.text "file_name"
    t.string "file_content_type"
    t.integer "file_content_length"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_attachments_on_user_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "title"
    t.integer "contents_count", default: 0
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.jsonb "metadata", default: {}, null: false
    t.uuid "key"
    t.jsonb "schema"
    t.index ["key"], name: "index_collections_on_key", unique: true
    t.index ["schema"], name: "index_collections_on_schema", using: :gin
    t.index ["slug"], name: "index_collections_on_slug"
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "contents", force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.string "entity_type"
    t.bigint "entity_id"
    t.jsonb "metadata", default: {}, null: false
    t.index ["collection_id", "entity_id", "entity_type"], name: "index_contents_on_collection_id_and_entity_id_and_entity_type"
    t.index ["collection_id"], name: "index_contents_on_collection_id"
    t.index ["entity_type", "entity_id"], name: "index_contents_on_entity_type_and_entity_id"
    t.index ["user_id"], name: "index_contents_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "images", force: :cascade do |t|
    t.text "url"
    t.text "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "width"
    t.integer "height"
    t.text "file_name"
    t.string "file_content_type"
    t.integer "file_content_length"
    t.index ["url"], name: "index_images_on_url", unique: true
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "links", force: :cascade do |t|
    t.text "url"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "texts", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_texts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "username", null: false
    t.string "crypted_password", null: false
    t.string "salt", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at", precision: nil
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at", precision: nil
    t.datetime "reset_password_email_sent_at", precision: nil
    t.string "slug"
    t.string "phone_number"
    t.jsonb "subscriptions", default: [], null: false
    t.string "customer_id"
    t.index ["customer_id"], name: "index_users_on_customer_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "attachments", "users"
  add_foreign_key "links", "users"
  add_foreign_key "texts", "users"
end
