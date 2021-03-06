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

ActiveRecord::Schema.define(version: 20141021080215) do

  create_table "companies", force: true do |t|
    t.integer  "angel_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "logo_url"
    t.text     "product_desc"
    t.text     "high_concept"
    t.text     "markets"
    t.string   "raising_amount"
    t.string   "pre_money_valuation"
    t.string   "url"
    t.string   "location"
    t.string   "raised_amount"
  end

  create_table "relationships", force: true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.boolean  "following"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "token"
    t.string   "name"
    t.integer  "angel_id"
    t.string   "angel_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "investor"
    t.string   "twitter_id"
  end

end
