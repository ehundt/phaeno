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

ActiveRecord::Schema.define(version: 20160106124901) do

  create_table "indicators", force: :cascade do |t|
    t.integer  "object_id",  null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filename"
  end

  create_table "phaenological_seasons", force: :cascade do |t|
    t.integer  "season",     null: false
    t.integer  "station_id", null: false
    t.date     "start"
    t.date     "stop"
    t.boolean  "active",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phases", force: :cascade do |t|
    t.integer  "phase_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "season_indications", force: :cascade do |t|
    t.integer "indicator_id", null: false
    t.integer "phase_id",     null: false
    t.integer "season",       null: false
  end

  create_table "stations", force: :cascade do |t|
    t.integer  "stations_id", null: false
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
