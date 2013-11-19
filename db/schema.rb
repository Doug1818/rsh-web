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

ActiveRecord::Schema.define(version: 20131119031300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: true do |t|
    t.integer  "program_id"
    t.integer  "action_type"
    t.integer  "streak"
    t.integer  "sequence"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "big_steps", force: true do |t|
    t.integer  "program_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coaches", force: true do |t|
    t.integer  "practice_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "gender"
    t.string   "avatar"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role"
    t.string   "invite_token"
  end

  add_index "coaches", ["email"], name: "index_coaches_on_email", unique: true, using: :btree
  add_index "coaches", ["reset_password_token"], name: "index_coaches_on_reset_password_token", unique: true, using: :btree

  create_table "practices", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "state"
    t.string   "city"
    t.string   "zip"
    t.integer  "status"
    t.string   "stripe_customer_id"
    t.string   "stripe_card_type"
    t.string   "stripe_card_last4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programs", force: true do |t|
    t.integer  "coach_id"
    t.integer  "user_id"
    t.datetime "state_date"
    t.text     "purpose"
    t.text     "goal"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invite_token"
  end

  create_table "reminders", force: true do |t|
    t.integer  "program_id"
    t.text     "body"
    t.integer  "frequency"
    t.datetime "send_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "small_steps", force: true do |t|
    t.integer  "big_step_id"
    t.string   "name"
    t.integer  "week_number"
    t.integer  "frequency"
    t.integer  "times_per_week"
    t.boolean  "sunday"
    t.boolean  "monday"
    t.boolean  "tuesday"
    t.boolean  "wednesday"
    t.boolean  "thursday"
    t.boolean  "friday"
    t.boolean  "saturday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "program_id"
  end

  create_table "supporters", force: true do |t|
    t.integer  "program_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todos", force: true do |t|
    t.integer  "program_id"
    t.text     "body"
    t.integer  "status",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.integer  "status"
    t.string   "device_id"
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
