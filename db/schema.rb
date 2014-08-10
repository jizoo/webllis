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

ActiveRecord::Schema.define(version: 20140810112958) do

  create_table "allowed_sources", force: true do |t|
    t.string   "namespace",                  null: false
    t.integer  "octet1",                     null: false
    t.integer  "octet2",                     null: false
    t.integer  "octet3",                     null: false
    t.integer  "octet4",                     null: false
    t.boolean  "wildcard",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "allowed_sources", ["namespace", "octet1", "octet2", "octet3", "octet4"], name: "index_allowed_sources_on_namespace_and_octets", unique: true, using: :btree

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname",   null: false
    t.string   "image",      null: false
  end

  add_index "authentications", ["uid", "provider"], name: "index_authentications_on_uid_and_provider", unique: true, using: :btree
  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "post_id",                         null: false
    t.string   "content",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "root_id"
    t.integer  "parent_id"
    t.string   "type",                            null: false
    t.integer  "creator_id",                      null: false
    t.integer  "reader_id",                       null: false
    t.boolean  "creator_trashed", default: false
    t.boolean  "reader_trashed",  default: false
    t.boolean  "read",            default: false
    t.boolean  "deleted",         default: false
    t.datetime "read_at"
  end

  add_index "comments", ["creator_id", "creator_trashed", "created_at"], name: "index_comments_on_s_t_c", using: :btree
  add_index "comments", ["creator_id"], name: "index_comments_on_creator_id", using: :btree
  add_index "comments", ["parent_id"], name: "comments_parent_id_fk", using: :btree
  add_index "comments", ["post_id"], name: "comments_post_id_fk", using: :btree
  add_index "comments", ["reader_id", "read"], name: "index_comments_on_reader_id_and_read", using: :btree
  add_index "comments", ["reader_id", "reader_trashed", "created_at"], name: "index_comments_on_r_t_c", using: :btree
  add_index "comments", ["reader_id"], name: "index_comments_on_reader_id", using: :btree
  add_index "comments", ["root_id", "created_at"], name: "index_comments_on_root_id_and_deleted_and_created_at", using: :btree
  add_index "comments", ["type"], name: "index_comments_on_type_and_user_id", using: :btree

  create_table "events", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "type",       null: false
    t.datetime "created_at", null: false
  end

  add_index "events", ["created_at"], name: "index_events_on_created_at", using: :btree
  add_index "events", ["user_id", "created_at"], name: "index_events_on_user_id_and_created_at", using: :btree

  create_table "favorites", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "post_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["post_id"], name: "index_favorites_on_post_id", using: :btree
  add_index "favorites", ["user_id", "post_id"], name: "index_favorites_on_user_id_and_post_id", unique: true, using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "user_id",     null: false
    t.string   "url",         null: false
    t.string   "title",       null: false
    t.string   "description"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["description"], name: "index_posts_on_description", using: :btree
  add_index "posts", ["title"], name: "index_posts_on_title", using: :btree
  add_index "posts", ["url"], name: "index_posts_on_url", using: :btree
  add_index "posts", ["user_id", "created_at"], name: "index_posts_on_user_id_and_created_at", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "follower_id", null: false
    t.integer  "followed_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                                   null: false
    t.string   "email",                                  null: false
    t.string   "email_for_index",                        null: false
    t.string   "hashed_password"
    t.boolean  "suspended",              default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "icon_image",                             null: false
    t.boolean  "editor",                 default: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email_for_index"], name: "index_users_on_email_for_index", unique: true, using: :btree
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "authentications", "users", name: "authentications_user_id_fk"

  add_foreign_key "comments", "comments", name: "comments_parent_id_fk", column: "parent_id"
  add_foreign_key "comments", "comments", name: "comments_root_id_fk", column: "root_id"
  add_foreign_key "comments", "posts", name: "comments_post_id_fk"
  add_foreign_key "comments", "users", name: "comments_creator_id_fk", column: "creator_id"
  add_foreign_key "comments", "users", name: "comments_reader_id_fk", column: "reader_id"

  add_foreign_key "events", "users", name: "events_user_id_fk"

  add_foreign_key "posts", "users", name: "posts_user_id_fk"

end
