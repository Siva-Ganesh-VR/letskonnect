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

ActiveRecord::Schema[7.1].define(version: 2024_01_01_000009) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", id: :string, force: :cascade do |t|
    t.string "event_id", null: false
    t.string "from_user_id", null: false
    t.string "to_user_id", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "from_user_id", "to_user_id"], name: "index_connections_on_event_id_and_from_user_id_and_to_user_id", unique: true
  end

  create_table "event_sessions", id: :string, force: :cascade do |t|
    t.string "event_id", null: false
    t.string "speaker_id"
    t.string "title", null: false
    t.string "track", default: "Main stage"
    t.string "kind", default: "Talk"
    t.string "starts_at", null: false
    t.string "ends_at", null: false
    t.string "room", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_sessions_on_event_id"
  end

  create_table "events", id: :string, force: :cascade do |t|
    t.string "organizer_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "event_type", default: "Conference"
    t.string "tagline", default: ""
    t.text "description", default: ""
    t.string "location", default: ""
    t.string "start_date", null: false
    t.string "end_date", null: false
    t.string "status", default: "draft"
    t.string "hero_image", default: ""
    t.integer "capacity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
    t.index ["slug"], name: "index_events_on_slug", unique: true
    t.index ["status"], name: "index_events_on_status"
  end

  create_table "registrations", id: :string, force: :cascade do |t|
    t.string "event_id", null: false
    t.string "user_id", null: false
    t.string "ticket_tier_id", null: false
    t.string "code", null: false
    t.datetime "checked_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_registrations_on_code", unique: true
    t.index ["event_id", "user_id"], name: "index_registrations_on_event_id_and_user_id", unique: true
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "speakers", id: :string, force: :cascade do |t|
    t.string "event_id", null: false
    t.string "name", null: false
    t.string "title", default: ""
    t.string "company", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_speakers_on_event_id"
  end

  create_table "support_tickets", id: :string, force: :cascade do |t|
    t.string "tenant_id"
    t.string "submitted_by"
    t.string "subject", null: false
    t.text "body", default: ""
    t.string "priority", default: "normal"
    t.string "status", default: "open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority"], name: "index_support_tickets_on_priority"
    t.index ["status"], name: "index_support_tickets_on_status"
  end

  create_table "tenants", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.string "plan", default: "starter"
    t.string "status", default: "active"
    t.integer "monthly_cents", default: 0
    t.string "billing_email", default: ""
    t.date "joined_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_tiers", id: :string, force: :cascade do |t|
    t.string "event_id", null: false
    t.string "name", null: false
    t.integer "price_cents", default: 0
    t.integer "quantity", default: 100
    t.integer "sort_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_ticket_tiers_on_event_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "attendee", null: false
    t.string "title", default: ""
    t.string "company", default: ""
    t.text "interests", default: ""
    t.string "avatar_initials", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

end
