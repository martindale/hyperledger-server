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

ActiveRecord::Schema.define(version: 20140701091659) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "code"
    t.text     "public_key"
    t.integer  "ledger_id"
    t.integer  "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "prepared",   default: false
    t.boolean  "committed",  default: false
  end

  add_index "accounts", ["code"], name: "index_accounts_on_code", unique: true, using: :btree
  add_index "accounts", ["public_key"], name: "index_accounts_on_public_key", unique: true, using: :btree

  create_table "commit_confirmations", force: true do |t|
    t.string   "node"
    t.text     "signature"
    t.integer  "confirmable_id"
    t.string   "confirmable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commit_confirmations", ["confirmable_id", "confirmable_type"], name: "index_commit_polymorphic_reference", using: :btree

  create_table "consensus_nodes", force: true do |t|
    t.string   "url"
    t.text     "public_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", force: true do |t|
    t.integer  "ledger_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "prepared",   default: false
    t.boolean  "committed",  default: false
  end

  create_table "ledgers", force: true do |t|
    t.text     "public_key"
    t.string   "name"
    t.string   "url"
    t.integer  "primary_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "prepared",           default: false
    t.boolean  "committed",          default: false
  end

  add_index "ledgers", ["name"], name: "index_ledgers_on_name", unique: true, using: :btree
  add_index "ledgers", ["public_key"], name: "index_ledgers_on_public_key", unique: true, using: :btree

  create_table "prepare_confirmations", force: true do |t|
    t.string   "node"
    t.text     "signature"
    t.integer  "confirmable_id"
    t.string   "confirmable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prepare_confirmations", ["confirmable_id", "confirmable_type"], name: "index_prepare_polymorphic_reference", using: :btree

  create_table "transfers", force: true do |t|
    t.integer  "amount"
    t.integer  "source_id"
    t.integer  "destination_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "prepared",       default: false
    t.boolean  "committed",      default: false
  end

end
