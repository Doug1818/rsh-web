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

ActiveRecord::Schema.define(version: 20140430170545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "check_in_id"
    t.integer  "small_step_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "alerts", force: true do |t|
    t.integer  "program_id"
    t.integer  "action_type"
    t.integer  "streak"
    t.integer  "sequence"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.integer  "small_step_id"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "big_steps", force: true do |t|
    t.integer  "program_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "check_ins", force: true do |t|
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "week_id"
  end

  create_table "check_ins_excuses", id: false, force: true do |t|
    t.integer "check_in_id", null: false
    t.integer "excuse_id",   null: false
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
    t.string   "encrypted_password",     default: "",                           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role"
    t.string   "invite_token"
    t.string   "referral_code"
    t.string   "referred_by_code"
    t.string   "timezone",               default: "Eastern Time (US & Canada)"
  end

  add_index "coaches", ["email"], name: "index_coaches_on_email", unique: true, using: :btree
  add_index "coaches", ["reset_password_token"], name: "index_coaches_on_reset_password_token", unique: true, using: :btree

  create_table "coaches_programs", id: false, force: true do |t|
    t.integer "coach_id",   null: false
    t.integer "program_id", null: false
  end

  create_table "excuses", force: true do |t|
    t.integer  "practice_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leads", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "referred_by_code"
  end

  create_table "notes", force: true do |t|
    t.integer  "small_step_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.boolean  "free_pass_flag",       default: false
    t.integer  "upgrade_price"
    t.datetime "upgrade_price_set_at"
    t.boolean  "hipaa_compliant",      default: false
  end

  create_table "programs", force: true do |t|
    t.integer  "coach_id"
    t.integer  "user_id"
    t.string   "purpose"
    t.string   "goal"
    t.integer  "status",                         default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.datetime "nudge_at_time"
    t.integer  "activity_status",                default: 0
    t.string   "encrypted_authentication_token"
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "referrals", force: true do |t|
    t.integer  "coach_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reminders", force: true do |t|
    t.integer  "program_id"
    t.text     "body"
    t.integer  "frequency"
    t.datetime "send_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weekly_recurrence"
    t.integer  "day_of_week"
    t.integer  "daily_recurrence"
    t.date     "send_on"
    t.integer  "monthly_recurrence"
    t.integer  "status",             default: 0
    t.datetime "last_sent_at"
  end

  create_table "small_steps", force: true do |t|
    t.integer  "big_step_id"
    t.string   "name"
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

  create_table "small_steps_weeks", id: false, force: true do |t|
    t.integer "small_step_id", null: false
    t.integer "week_id",       null: false
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
    t.string   "encrypted_password",     default: "",                           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar"
    t.string   "phone"
    t.string   "timezone",               default: "Eastern Time (US & Canada)"
    t.boolean  "hipaa_compliant",        default: false
    t.string   "tv_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weeks", force: true do |t|
    t.integer  "program_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
