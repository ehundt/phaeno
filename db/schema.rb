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

ActiveRecord::Schema.define(version: 20160120122917) do

  create_table "phaenological_seasons", force: :cascade do |t|
    t.integer  "station_id", null: false
    t.date     "start"
    t.date     "stop"
    t.boolean  "active",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "season"
  end

  add_index "phaenological_seasons", ["season"], name: "index_phaenological_seasons_on_season"

  create_table "phases", force: :cascade do |t|
    t.integer  "dwd_phase_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plants", force: :cascade do |t|
    t.string   "dwd_object_id"
    t.string   "name",          null: false
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "season_indications", force: :cascade do |t|
    t.integer  "phase_id",   null: false
    t.integer  "plant_id"
    t.integer  "season"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "season_indications", ["plant_id"], name: "index_season_indications_on_plant_id"
  add_index "season_indications", ["season"], name: "index_season_indications_on_season"

  create_table "stations", force: :cascade do |t|
    t.integer  "dwd_station_id", null: false
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
