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

ActiveRecord::Schema.define(version: 20180219221030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "identities", force: :cascade do |t|
    t.string  "name"
    t.integer "side"
    t.string  "faction"
    t.string  "nrdb_code"
    t.string  "autocomplete"
    t.index ["side"], name: "index_identities_on_side", using: :btree
  end

  create_table "pairings", force: :cascade do |t|
    t.integer "round_id"
    t.integer "player1_id"
    t.integer "player2_id"
    t.integer "table_number"
    t.integer "score1"
    t.integer "score2"
    t.integer "side"
    t.index ["player1_id"], name: "index_pairings_on_player1_id", using: :btree
    t.index ["player2_id"], name: "index_pairings_on_player2_id", using: :btree
    t.index ["round_id"], name: "index_pairings_on_round_id", using: :btree
  end

  create_table "players", force: :cascade do |t|
    t.string  "name"
    t.integer "tournament_id"
    t.boolean "active",          default: true
    t.string  "corp_identity"
    t.string  "runner_identity"
    t.integer "seed"
    t.boolean "first_round_bye", default: false
    t.integer "previous_id"
    t.index ["tournament_id"], name: "index_players_on_tournament_id", using: :btree
  end

  create_table "registrations", force: :cascade do |t|
    t.integer "player_id"
    t.integer "stage_id"
    t.integer "seed"
    t.index ["player_id"], name: "index_registrations_on_player_id", using: :btree
    t.index ["stage_id"], name: "index_registrations_on_stage_id", using: :btree
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "number"
    t.boolean "completed",     default: false
    t.decimal "weight",        default: "1.0"
    t.integer "stage_id"
    t.index ["stage_id"], name: "index_rounds_on_stage_id", using: :btree
    t.index ["tournament_id"], name: "index_rounds_on_tournament_id", using: :btree
  end

  create_table "stages", force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "number",        default: 1
    t.integer "format",        default: 0, null: false
    t.index ["tournament_id"], name: "index_stages_on_tournament_id", using: :btree
  end

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.string   "abr_code"
    t.integer  "stage",       default: 0
    t.integer  "previous_id"
    t.integer  "user_id"
    t.string   "slug"
    t.date     "date"
    t.boolean  "private",     default: false
    t.index ["user_id"], name: "index_tournaments_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "nrdb_id"
    t.string   "nrdb_username"
    t.string   "nrdb_access_token"
    t.string   "nrdb_refresh_token"
    t.index ["nrdb_id"], name: "index_users_on_nrdb_id", using: :btree
  end

  add_foreign_key "pairings", "players", column: "player1_id"
  add_foreign_key "pairings", "players", column: "player2_id"
  add_foreign_key "pairings", "rounds"
  add_foreign_key "players", "tournaments"
  add_foreign_key "registrations", "players"
  add_foreign_key "registrations", "stages"
  add_foreign_key "rounds", "stages"
  add_foreign_key "rounds", "tournaments"
  add_foreign_key "stages", "tournaments"
  add_foreign_key "tournaments", "users"
end
