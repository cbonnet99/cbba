# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081202213611) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "slug"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "introduction"
    t.string   "state",           :default => "draft"
    t.datetime "published_at"
    t.text     "reason_reject"
    t.datetime "rejected_at"
    t.integer  "rejected_by_id"
    t.text     "comment_approve"
    t.datetime "approved_at"
    t.integer  "approved_by_id"
  end

  create_table "articles_subcategories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subcategory_id"
    t.integer  "article_id"
  end

  add_index "articles_subcategories", ["article_id"], :name => "index_articles_subcategories_on_article_id"
  add_index "articles_subcategories", ["subcategory_id"], :name => "index_articles_subcategories_on_subcategory_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "users_counter", :default => 0
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passwords", :force => true do |t|
    t.integer  "user_id"
    t.string   "reset_code"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "comment"
    t.string   "invoice_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "subcategories", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_counter", :default => 0
  end

  create_table "subcategories_users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subcategory_id"
    t.integer  "user_id"
  end

  add_index "subcategories_users", ["subcategory_id"], :name => "index_subcategories_users_on_subcategory_id"
  add_index "subcategories_users", ["user_id"], :name => "index_subcategories_users_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer "taggable_id"
    t.integer "tag_id"
    t.string  "taggable_type"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_events", :force => true do |t|
    t.string   "source_url"
    t.string   "destination_url"
    t.string   "remote_ip"
    t.datetime "logged_at"
    t.text     "extra_data"
    t.string   "event_type"
    t.integer  "user_id"
    t.integer  "article_id"
    t.integer  "category_id"
    t.integer  "subcategory_id"
    t.integer  "region_id"
    t.integer  "district_id"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",                :limit => 100, :default => ""
    t.string   "last_name",                 :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.string   "activation_code",           :limit => 40
    t.string   "state",                                    :default => "passive"
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
    t.boolean  "receive_newsletter",                       :default => true
    t.boolean  "professional",                             :default => false
    t.boolean  "free_listing"
    t.string   "business_name"
    t.string   "address1"
    t.string   "suburb"
    t.string   "city"
    t.integer  "district_id"
    t.string   "phone"
    t.string   "mobile"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
