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

ActiveRecord::Schema.define(version: 20151115062632) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actors", force: :cascade do |t|
    t.string   "type",        null: false
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "actors", ["type"], name: "index_actors_on_type", using: :btree

  create_table "callbacks", force: :cascade do |t|
    t.string   "type",                        null: false
    t.integer  "routine_id",                  null: false
    t.integer  "target_id",                   null: false
    t.string   "target_type",                 null: false
    t.integer  "delay"
    t.boolean  "once",        default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "callbacks", ["routine_id"], name: "index_callbacks_on_routine_id", using: :btree
  add_index "callbacks", ["target_type", "target_id"], name: "index_callbacks_on_target_type_and_target_id", using: :btree
  add_index "callbacks", ["type", "routine_id", "target_type", "target_id"], name: "index_callbacks_on_type_and_routine_id_and_target", unique: true, using: :btree
  add_index "callbacks", ["type"], name: "index_callbacks_on_type", using: :btree

  create_table "listeners", force: :cascade do |t|
    t.integer  "routine_id", null: false
    t.integer  "sensor_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "listeners", ["routine_id", "sensor_id"], name: "index_listeners_on_routine_id_and_sensor_id", unique: true, using: :btree
  add_index "listeners", ["routine_id"], name: "index_listeners_on_routine_id", using: :btree
  add_index "listeners", ["sensor_id"], name: "index_listeners_on_sensor_id", using: :btree

  create_table "routines", force: :cascade do |t|
    t.string   "name",                        null: false
    t.text     "description"
    t.time     "starts_at"
    t.time     "ends_at"
    t.integer  "duration"
    t.integer  "repeats_at"
    t.boolean  "active",      default: true,  null: false
    t.boolean  "once",        default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "sensors", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                                          null: false
    t.string   "encrypted_password", limit: 128,                 null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,                 null: false
    t.boolean  "admin",                          default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  add_foreign_key "callbacks", "routines", on_delete: :cascade
  add_foreign_key "listeners", "routines", on_delete: :cascade
  add_foreign_key "listeners", "sensors", on_delete: :cascade
end
