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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120709221550) do

  create_table "contributions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "reward_id"
    t.integer  "payment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.float    "amount"
  end

  create_table "payments", :force => true do |t|
    t.float    "amount"
    t.string   "transaction_provider"
    t.string   "transaction_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "caller_reference"
    t.string   "transaction_status"
    t.string   "token_id"
  end

  create_table "projects", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "name"
    t.text     "short_description"
    t.text     "long_description",  :limit => 255
    t.string   "video"
    t.float    "funding_needed"
    t.string   "proposer_name"
    t.string   "picture"
  end

  create_table "rewards", :force => true do |t|
    t.string   "name"
    t.string   "short_description"
    t.text     "long_description"
    t.integer  "project_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.float    "minimum_contribution"
    t.boolean  "limited_quantity"
    t.integer  "max_available"
    t.integer  "current_available"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

end
