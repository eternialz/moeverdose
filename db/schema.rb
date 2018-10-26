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

ActiveRecord::Schema.define(version: 2018_10_15_215858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "aliases", force: :cascade do |t|
    t.string "name"
    t.boolean "main", default: false
    t.bigint "tag_id"
    t.index ["tag_id"], name: "index_aliases_on_tag_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.text "biography"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tag_id"
    t.index ["tag_id"], name: "index_authors_on_tag_id"
  end

  create_table "blacklisted_tags_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.index ["user_id", "tag_id"], name: "index_blacklisted_tags_users_on_user_id_and_tag_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "text"
    t.boolean "report", default: false
    t.text "report_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "report_user_id"
    t.bigint "post_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["report_user_id"], name: "index_comments_on_report_user_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "disliked_posts_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.index ["user_id", "post_id"], name: "index_disliked_posts_users_on_user_id_and_post_id"
  end

  create_table "favorites_posts_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.index ["user_id", "post_id"], name: "index_favorites_posts_users_on_user_id_and_post_id"
  end

  create_table "favorites_tags_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.index ["user_id", "tag_id"], name: "index_favorites_tags_users_on_user_id_and_tag_id"
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.integer "rank", default: 0
    t.boolean "final", default: false
    t.integer "max_exp"
    t.string "color", default: "#1AB"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "liked_posts_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.index ["user_id", "post_id"], name: "index_liked_posts_users_on_user_id_and_post_id"
  end

  create_table "news", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "md5"
    t.integer "height", default: 0
    t.integer "width", default: 0
    t.integer "overdose", default: 0
    t.integer "moe_shortage", default: 0
    t.string "title"
    t.string "source"
    t.text "description"
    t.boolean "report", default: false
    t.text "report_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "report_user_id"
    t.bigint "author_id"
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["report_user_id"], name: "index_posts_on_report_user_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "posts_tags", id: false, force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "tag_id", null: false
  end

  create_table "reported_posts_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "type"
    t.integer "posts_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "biography"
    t.string "website"
    t.string "twitter"
    t.string "facebook"
    t.integer "upload_count", default: 0
    t.integer "exp", default: 0
    t.boolean "report"
    t.boolean "banned"
    t.string "role"
    t.string "favorites_tags"
    t.string "blacklisted_tags"
    t.bigint "level_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["level_id"], name: "index_users_on_level_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
