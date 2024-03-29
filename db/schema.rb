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

ActiveRecord::Schema.define(version: 2022_05_13_164415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "master_playlists", force: :cascade do |t|
    t.string "name"
    t.string "spotify_id"
    t.bigint "user_id"
    t.string "image_url"
    t.boolean "disabled", default: false
    t.date "last_checked"
    t.date "last_updated"
    t.integer "track_count"
    t.string "last_song_added"
    t.json "top_artists"
    t.json "missing_alphatunez_letters"
    t.index ["user_id"], name: "index_master_playlists_on_user_id"
  end

  create_table "minion_playlists", force: :cascade do |t|
    t.string "name"
    t.string "spotify_id"
    t.bigint "master_playlist_id"
    t.bigint "user_id"
    t.string "image_url"
    t.boolean "is_valid", default: true
    t.boolean "disabled", default: false
    t.index ["master_playlist_id"], name: "index_minion_playlists_on_master_playlist_id"
    t.index ["user_id"], name: "index_minion_playlists_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "image"
    t.text "spotify_hash"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "master_playlists", "users"
  add_foreign_key "minion_playlists", "master_playlists"
  add_foreign_key "minion_playlists", "users"
end
