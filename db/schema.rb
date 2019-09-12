# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_12_113849) do

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "post_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
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

  create_table "permissions", force: :cascade do |t|
    t.boolean "consent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "permissions_type_id"
    t.index ["permissions_type_id"], name: "index_permissions_on_permissions_type_id"
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "permissions_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "author_id"
    t.index ["author_id"], name: "index_posts_on_author_id"
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

  create_table "reports", force: :cascade do |t|
    t.text "reason"
    t.string "reportable_type"
    t.bigint "reportable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable_type_and_reportable_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
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
    t.boolean "banned"
    t.string "role"
    t.bigint "level_id"
    t.date "deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["level_id"], name: "index_users_on_level_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "aliases", "tags", on_delete: :cascade
  add_foreign_key "authors", "tags", on_delete: :nullify
  add_foreign_key "blacklisted_tags_users", "tags", on_delete: :cascade
  add_foreign_key "blacklisted_tags_users", "users", on_delete: :cascade
  add_foreign_key "comments", "posts", on_delete: :nullify
  add_foreign_key "comments", "users", on_delete: :nullify
  add_foreign_key "disliked_posts_users", "posts", on_delete: :cascade
  add_foreign_key "disliked_posts_users", "users", on_delete: :cascade
  add_foreign_key "favorites_posts_users", "posts", on_delete: :cascade
  add_foreign_key "favorites_posts_users", "users", on_delete: :cascade
  add_foreign_key "favorites_tags_users", "tags", on_delete: :cascade
  add_foreign_key "favorites_tags_users", "users", on_delete: :cascade
  add_foreign_key "liked_posts_users", "posts", on_delete: :cascade
  add_foreign_key "liked_posts_users", "users", on_delete: :cascade
  add_foreign_key "permissions", "permissions_types", on_delete: :cascade
  add_foreign_key "permissions", "users", on_delete: :cascade
  add_foreign_key "posts", "authors", on_delete: :nullify
  add_foreign_key "posts", "users", on_delete: :nullify
  add_foreign_key "posts_tags", "posts", on_delete: :cascade
  add_foreign_key "posts_tags", "tags", on_delete: :cascade
  add_foreign_key "reports", "users", on_delete: :nullify
  add_foreign_key "users", "levels", on_delete: :nullify
end
