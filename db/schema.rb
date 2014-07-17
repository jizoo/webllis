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

ActiveRecord::Schema.define(version: 20140717042959) do

  create_table "administrators", force: true do |t|
    t.string   "email",                           null: false
    t.string   "email_for_index",                 null: false
    t.string   "hashed_password",                 null: false
    t.boolean  "suspended",       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "administrators", ["email_for_index"], name: "index_administrators_on_email_for_index", unique: true, using: :btree
  add_index "administrators", ["remember_token"], name: "index_administrators_on_remember_token", using: :btree

  create_table "events", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "type",       null: false
    t.datetime "created_at", null: false
  end

  add_index "events", ["created_at"], name: "index_events_on_created_at", using: :btree
  add_index "events", ["user_id", "created_at"], name: "index_events_on_user_id_and_created_at", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "user_id",     null: false
    t.string   "url",         null: false
    t.string   "title",       null: false
    t.string   "description"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["title"], name: "index_posts_on_title", using: :btree
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

  create_table "users", force: true do |t|
    t.string   "name",                            null: false
    t.string   "email",                           null: false
    t.string   "email_for_index",                 null: false
    t.string   "hashed_password",                 null: false
    t.boolean  "suspended",       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["email_for_index"], name: "index_users_on_email_for_index", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "events", "users", name: "events_user_id_fk"

  add_foreign_key "posts", "users", name: "posts_user_id_fk"

end
