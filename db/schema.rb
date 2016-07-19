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

ActiveRecord::Schema.define(version: 20160719064146) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "actors", force: :cascade do |t|
    t.string   "type",        null: false
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "group_id",    null: false
    t.string   "icon"
    t.hstore   "config"
  end

  add_index "actors", ["group_id"], name: "index_actors_on_group_id", using: :btree
  add_index "actors", ["name", "group_id"], name: "index_actors_on_name_and_group_id", unique: true, using: :btree
  add_index "actors", ["type"], name: "index_actors_on_type", using: :btree

  create_table "callbacks", force: :cascade do |t|
    t.string   "type",                         null: false
    t.integer  "target_id",                    null: false
    t.string   "target_type",                  null: false
    t.integer  "delay"
    t.boolean  "once",         default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.json     "payload"
    t.integer  "routine_id",                   null: false
    t.string   "routine_type",                 null: false
  end

  add_index "callbacks", ["routine_type", "routine_id"], name: "index_callbacks_on_routine_type_and_routine_id", using: :btree
  add_index "callbacks", ["target_type", "target_id"], name: "index_callbacks_on_target_type_and_target_id", using: :btree
  add_index "callbacks", ["type"], name: "index_callbacks_on_type", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "routine_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "kind",       null: false
  end

  add_index "events", ["routine_id"], name: "index_events_on_routine_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",           null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "nodered_host"
    t.hstore   "nodered_config"
  end

  create_table "listeners", force: :cascade do |t|
    t.integer  "sensor_id",    null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.float    "gt"
    t.float    "lt"
    t.integer  "routine_id",   null: false
    t.string   "routine_type", null: false
  end

  add_index "listeners", ["routine_type", "routine_id"], name: "index_listeners_on_routine_type_and_routine_id", using: :btree
  add_index "listeners", ["sensor_id"], name: "index_listeners_on_sensor_id", using: :btree

  create_table "periodic_routines", force: :cascade do |t|
    t.string   "name",                        null: false
    t.text     "description"
    t.time     "starts_at",                   null: false
    t.time     "ends_at",                     null: false
    t.integer  "repeats_at"
    t.boolean  "active",      default: true,  null: false
    t.boolean  "once",        default: false, null: false
    t.integer  "group_id",                    null: false
    t.string   "flow_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "periodic_routines", ["group_id"], name: "index_periodic_routines_on_group_id", using: :btree
  add_index "periodic_routines", ["name", "group_id"], name: "index_periodic_routines_on_name_and_group_id", unique: true, using: :btree

  create_table "routines", force: :cascade do |t|
    t.string   "name",                         null: false
    t.text     "description"
    t.time     "starts_at"
    t.time     "ends_at"
    t.integer  "duration"
    t.integer  "repeats_at"
    t.boolean  "active",       default: true,  null: false
    t.boolean  "once",         default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "group_id",                     null: false
    t.integer  "events_count", default: 0,     null: false
    t.boolean  "all_day",      default: false, null: false
    t.string   "flow_id"
  end

  add_index "routines", ["group_id"], name: "index_routines_on_group_id", using: :btree
  add_index "routines", ["name", "group_id"], name: "index_routines_on_name_and_group_id", unique: true, using: :btree

  create_table "rule_based_routines", force: :cascade do |t|
    t.string   "name",                       null: false
    t.text     "description"
    t.integer  "repeats_at"
    t.boolean  "active",      default: true, null: false
    t.integer  "group_id",                   null: false
    t.string   "flow_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "rule_based_routines", ["group_id"], name: "index_rule_based_routines_on_group_id", using: :btree
  add_index "rule_based_routines", ["name", "group_id"], name: "index_rule_based_routines_on_name_and_group_id", unique: true, using: :btree

  create_table "sensors", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "group_id",    null: false
    t.integer  "kind",        null: false
    t.string   "icon"
    t.string   "type",        null: false
  end

  add_index "sensors", ["group_id"], name: "index_sensors_on_group_id", using: :btree
  add_index "sensors", ["name", "group_id"], name: "index_sensors_on_name_and_group_id", unique: true, using: :btree

  create_table "time_based_routines", force: :cascade do |t|
    t.string   "name",                       null: false
    t.text     "description"
    t.time     "triggers_at",                null: false
    t.integer  "repeats_at"
    t.boolean  "active",      default: true, null: false
    t.integer  "group_id",                   null: false
    t.string   "flow_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "time_based_routines", ["group_id"], name: "index_time_based_routines_on_group_id", using: :btree
  add_index "time_based_routines", ["name", "group_id"], name: "index_time_based_routines_on_name_and_group_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                                          null: false
    t.string   "encrypted_password", limit: 128,                 null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,                 null: false
    t.boolean  "admin",                          default: false, null: false
    t.integer  "group_id",                                       null: false
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "actors", "groups", on_delete: :cascade
  add_foreign_key "listeners", "sensors", on_delete: :cascade
  add_foreign_key "periodic_routines", "groups", on_delete: :cascade
  add_foreign_key "routines", "groups", on_delete: :cascade
  add_foreign_key "rule_based_routines", "groups", on_delete: :cascade
  add_foreign_key "sensors", "groups", on_delete: :cascade
  add_foreign_key "time_based_routines", "groups", on_delete: :cascade
  add_foreign_key "users", "groups", on_delete: :cascade
end
