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

ActiveRecord::Schema.define(version: 20160425161736) do

  create_table "admin_dbs", force: :cascade do |t|
    t.string   "com_name",       limit: 255
    t.string   "com_type",       limit: 255
    t.date     "purchase_date"
    t.string   "company_type",   limit: 255
    t.integer  "quantity",       limit: 4
    t.float    "purchase_unit",  limit: 24
    t.float    "est_price_soft", limit: 24
    t.float    "est_price_pp",   limit: 24
    t.float    "market_value",   limit: 24
    t.string   "exp_life",       limit: 255
    t.string   "values_used",    limit: 255
    t.date     "date_purchase"
    t.string   "remain_life",    limit: 255
    t.string   "inflation",      limit: 255
    t.string   "obsolete",       limit: 255
    t.float    "final_value",    limit: 24,  default: 0.0
    t.integer  "project_id",     limit: 4
    t.string   "import_export",  limit: 255
    t.string   "location",       limit: 255
    t.string   "source",         limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "company_type", limit: 255
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "excel_data", force: :cascade do |t|
    t.string   "com_name",       limit: 255
    t.string   "com_type",       limit: 255
    t.date     "purchase_date"
    t.string   "company_type",   limit: 255
    t.integer  "quantity",       limit: 4
    t.float    "purchase_unit",  limit: 24
    t.float    "est_price_soft", limit: 24
    t.float    "est_price_pp",   limit: 24
    t.float    "market_value",   limit: 24
    t.string   "exp_life",       limit: 255
    t.string   "values_used",    limit: 255
    t.date     "date_purchase"
    t.string   "remain_life",    limit: 255
    t.string   "inflation",      limit: 255
    t.string   "obsolete",       limit: 255
    t.float    "final_value",    limit: 24,  default: 0.0
    t.integer  "project_id",     limit: 4
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "import_export",  limit: 255
    t.string   "location",       limit: 255
    t.string   "source",         limit: 255
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "bank_name",         limit: 255
    t.date     "end_date"
    t.string   "company_type",      limit: 255
    t.integer  "company_id",        limit: 4
    t.integer  "appointed_person",  limit: 4
    t.integer  "executive",         limit: 4
    t.string   "inflation",         limit: 255
    t.string   "obsolete",          limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
  end

  create_table "scrap_records", force: :cascade do |t|
    t.string   "hs_code",           limit: 255
    t.string   "desc",              limit: 255
    t.string   "country",           limit: 255
    t.float    "price_pp",          limit: 24
    t.integer  "admin_db_id",       limit: 4
    t.integer  "excel_datum_id",    limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "source",            limit: 255
    t.string   "name",              limit: 255
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.integer  "role_cd",                limit: 4
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "company_id",             limit: 4
    t.string   "name",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
