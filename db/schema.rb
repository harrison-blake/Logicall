# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_02_02_171335) do
  create_table "accounts", force: :cascade do |t|
    t.string "industry"
    t.string "company_name"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "telnyx_phone_number"
    t.string "twilio_phone_number"
    t.boolean "auto_process_transcripts", default: false
    t.integer "default_intake_owner_id"
    t.index ["default_intake_owner_id"], name: "index_accounts_on_default_intake_owner_id"
    t.index ["telnyx_phone_number"], name: "index_accounts_on_telnyx_phone_number", unique: true
    t.index ["twilio_phone_number"], name: "index_accounts_on_twilio_phone_number", unique: true
  end

  create_table "assistant_logs", force: :cascade do |t|
    t.string "action_type"
    t.text "details"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_assistant_logs_on_user_id"
  end

  create_table "call_transcripts", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "conversation_id"
    t.string "caller_phone"
    t.text "transcript"
    t.integer "call_duration"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "intake_id"
    t.index ["account_id"], name: "index_call_transcripts_on_account_id"
    t.index ["intake_id"], name: "index_call_transcripts_on_intake_id"
  end

  create_table "intakes", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "details"
    t.string "urgency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.integer "status", default: 0
    t.text "staff_notes"
    t.integer "user_id"
    t.index ["user_id"], name: "index_intakes_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.integer "intake_id", null: false
    t.string "subject"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["intake_id"], name: "index_tasks_on_intake_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.integer "account_id", null: false
    t.integer "role", default: 2
    t.index ["account_id"], name: "index_users_on_account_id"
  end

  add_foreign_key "accounts", "users", column: "default_intake_owner_id"
  add_foreign_key "assistant_logs", "users"
  add_foreign_key "call_transcripts", "accounts"
  add_foreign_key "call_transcripts", "intakes"
  add_foreign_key "intakes", "users"
  add_foreign_key "tasks", "intakes"
  add_foreign_key "users", "accounts"
end
