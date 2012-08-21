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

ActiveRecord::Schema.define(:version => 20120820160742) do

  create_table "contributions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "reward_id"
    t.integer  "payment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "amount"
    t.string   "status"
  end

  create_table "payments", :force => true do |t|
    t.float    "amount"
    t.string   "transaction_provider"
    t.string   "transaction_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "caller_reference"
    t.string   "transaction_status"
    t.string   "token_id"
    t.string   "amazon_fps_status_code"
    t.string   "amazon_fps_transaction_status"
    t.string   "stripe_token"
  end

  create_table "projects", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "name"
    t.text     "short_description"
    t.text     "long_description",  :limit => 255
    t.string   "video"
    t.integer  "funding_needed"
    t.string   "proposer_name"
    t.string   "picture"
    t.integer  "proposer_id"
  end

  create_table "rewards", :force => true do |t|
    t.string   "name"
    t.string   "short_description"
    t.text     "long_description"
    t.integer  "project_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "minimum_contribution"
    t.integer  "current_available"
    t.integer  "limited_quantity"
  end

  create_table "user_signups", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",                  :default => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
