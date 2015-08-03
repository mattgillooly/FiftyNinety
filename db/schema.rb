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

ActiveRecord::Schema.define(version: 20150803222004) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "skirmishes", force: true do |t|
    t.datetime "starts_at"
    t.string   "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skirmishes", ["starts_at"], name: "index_skirmishes_on_starts_at", using: :btree

  create_table "songs", force: true do |t|
    t.integer  "remote_id",   null: false
    t.string   "title",       null: false
    t.string   "username",    null: false
    t.string   "user_href",   null: false
    t.boolean  "has_demo",    null: false
    t.string   "demo_href"
    t.datetime "posted_date", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "liner_notes"
    t.text     "lyrics"
  end

  add_index "songs", ["remote_id"], name: "index_songs_on_remote_id", unique: true, using: :btree
  add_index "songs", ["user_href", "posted_date"], name: "index_songs_on_user_href_and_posted_date", using: :btree

end
