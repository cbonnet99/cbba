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

ActiveRecord::Schema.define(:version => 20110322072422) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "slug"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "introduction"
    t.string   "state",                                    :default => "draft"
    t.datetime "published_at"
    t.text     "reason_reject"
    t.datetime "rejected_at"
    t.integer  "rejected_by_id"
    t.text     "comment_approve"
    t.datetime "approved_at"
    t.integer  "approved_by_id"
    t.string   "lead",                      :limit => 500
    t.string   "about",                     :limit => 600
    t.datetime "last_homepage_featured_at"
    t.integer  "country_id"
    t.integer  "view_counts",                              :default => 0
    t.integer  "monthly_view_counts",                      :default => 0
    t.boolean  "homepage_featured"
  end

  add_index "articles", ["state"], :name => "index_articles_on_state"

  create_table "articles_blog_categories", :force => true do |t|
    t.integer  "article_id"
    t.integer  "blog_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles_blog_subcategories", :force => true do |t|
    t.integer  "article_id"
    t.integer  "blog_subcategory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles_categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "article_id"
    t.integer  "position"
  end

  add_index "articles_categories", ["article_id"], :name => "index_articles_categories_on_article_id"
  add_index "articles_categories", ["category_id"], :name => "index_articles_categories_on_category_id"

  create_table "articles_newsletters", :force => true do |t|
    t.integer  "article_id"
    t.integer  "newsletter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles_subcategories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subcategory_id"
    t.integer  "article_id"
  end

  add_index "articles_subcategories", ["article_id"], :name => "index_articles_subcategories_on_article_id"
  add_index "articles_subcategories", ["subcategory_id"], :name => "index_articles_subcategories_on_subcategory_id"

  create_table "blog_categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_subcategories", :force => true do |t|
    t.integer  "blog_category_id"
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "users_counter", :default => 0
    t.string   "slug"
    t.text     "description"
    t.string   "label"
  end

  add_index "categories", ["name", "position"], :name => "index_categories_on_position_and_name"

  create_table "categories_users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "position"
  end

  add_index "categories_users", ["category_id"], :name => "index_categories_users_on_category_id"
  add_index "categories_users", ["user_id"], :name => "index_categories_users_on_user_id"

  create_table "charities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default_choice"
  end

  create_table "contacts", :force => true do |t|
    t.string   "email"
    t.boolean  "receive_newsletter"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "region_id"
    t.integer  "district_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unsubscribe_token"
    t.datetime "activated_at"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.string   "activation_code",           :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "state"
    t.integer  "country_id"
  end

  create_table "counters", :force => true do |t|
    t.string   "title"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "class_name"
    t.string   "state",        :default => "draft"
    t.integer  "country_id"
    t.string   "count_method"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_code"
    t.string   "top_domain"
    t.string   "example_locations"
    t.boolean  "default_only_show_own"
  end

  create_table "countries_subcategories", :force => true do |t|
    t.integer  "country_id"
    t.integer  "subcategory_id"
    t.integer  "published_articles_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "country_id"
  end

  add_index "districts", ["id"], :name => "index_districts_on_id"

  create_table "friend_messages", :force => true do |t|
    t.string   "from_email"
    t.string   "from_name"
    t.string   "to_email"
    t.string   "to_name"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from_user_id"
    t.datetime "sent_at"
  end

  create_table "gift_vouchers", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "author_id"
    t.string   "slug"
    t.string   "state",           :default => "draft"
    t.string   "string",          :default => "draft"
    t.datetime "published_at"
    t.datetime "reason_reject"
    t.datetime "rejected_at"
    t.integer  "rejected_by_id"
    t.text     "comment_approve"
    t.datetime "approved_at"
    t.integer  "approved_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subcategory_id"
    t.boolean  "nation_wide",     :default => false
    t.integer  "country_id"
  end

  create_table "gift_vouchers_newsletters", :force => true do |t|
    t.integer  "gift_voucher_id"
    t.integer  "newsletter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "how_to_steps", :force => true do |t|
    t.integer  "how_to_id"
    t.string   "title"
    t.text     "body"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "how_tos", :force => true do |t|
    t.string   "title"
    t.string   "summary",         :limit => 500
    t.string   "step_label"
    t.datetime "published_at"
    t.text     "reason_reject"
    t.datetime "rejected_at"
    t.integer  "rejected_by_id"
    t.text     "comment_approve"
    t.datetime "approved_at"
    t.integer  "approved_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.string   "state",                          :default => "draft"
    t.string   "slug"
    t.integer  "feature_rank"
    t.integer  "country_id"
  end

  add_index "how_tos", ["state"], :name => "index_how_tos_on_state"

  create_table "how_tos_categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "how_to_id"
    t.integer  "position"
  end

  add_index "how_tos_categories", ["category_id"], :name => "index_how_tos_categories_on_category_id"
  add_index "how_tos_categories", ["how_to_id"], :name => "index_how_tos_categories_on_how_to_id"

  create_table "how_tos_subcategories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subcategory_id"
    t.integer  "how_to_id"
    t.integer  "position"
  end

  add_index "how_tos_subcategories", ["how_to_id"], :name => "index_how_tos_subcategories_on_how_to_id"
  add_index "how_tos_subcategories", ["subcategory_id"], :name => "index_how_tos_subcategories_on_subcategory_id"

  create_table "invoices", :force => true do |t|
    t.integer  "payment_id"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "pdf"
  end

  create_table "js_counters", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value"
    t.integer  "country_id"
  end

  create_table "mass_email_instances", :force => true do |t|
    t.integer  "user_id"
    t.integer  "mass_email_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mass_emails", :force => true do |t|
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "test_sent_at"
    t.integer  "test_sent_to_id"
    t.datetime "sent_at"
    t.string   "email_type"
    t.integer  "creator_id"
    t.text     "sent_to"
    t.integer  "newsletter_id"
    t.string   "recipients"
    t.integer  "sent_by_id"
    t.integer  "country_id"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.text     "body"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
  end

  create_table "newsletters", :force => true do |t|
    t.string   "title"
    t.text     "main_article"
    t.text     "competition"
    t.text     "bam_news"
    t.text     "upcoming_events"
    t.text     "quotation_quiz"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.datetime "published_at"
    t.integer  "publisher_id"
    t.integer  "author_id"
    t.string   "custom1_title"
    t.text     "custom1_body"
    t.string   "custom2_title"
    t.text     "custom2_body"
    t.string   "custom3_title"
    t.text     "custom3_body"
    t.string   "custom4_title"
    t.text     "custom4_body"
    t.text     "body"
  end

  create_table "newsletters_special_offers", :force => true do |t|
    t.integer  "newsletter_id"
    t.integer  "special_offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "newsletters_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "newsletter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "order_number"
    t.boolean  "photo"
    t.boolean  "highlighted"
    t.integer  "special_offers"
    t.integer  "gift_vouchers"
    t.boolean  "whole_package"
    t.string   "state"
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

  create_table "payment_transactions", :force => true do |t|
    t.integer  "payment_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
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
    t.string   "payment_type"
    t.string   "status",            :default => "pending"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "address1"
    t.string   "city"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.integer  "gst"
    t.integer  "discount"
    t.string   "code"
    t.boolean  "debit"
    t.integer  "charity_id"
    t.string   "payment_card_type"
    t.integer  "order_id"
    t.datetime "notified_at"
    t.integer  "stored_token_id"
    t.string   "currency"
  end

  create_table "quotes", :force => true do |t|
    t.text     "body"
    t.string   "author"
    t.boolean  "homepage_featured"
    t.datetime "last_homepage_featured_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recommendations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recommended_user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "country_id"
  end

  add_index "regions", ["id"], :name => "index_regions_on_id"

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

  create_table "special_offers", :force => true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "slug"
    t.string   "filename"
    t.string   "state",           :default => "draft"
    t.datetime "published_at"
    t.text     "reason_reject"
    t.datetime "rejected_at"
    t.integer  "rejected_by_id"
    t.text     "comment_approve"
    t.datetime "approved_at"
    t.integer  "approved_by_id"
    t.integer  "author_id"
    t.integer  "subcategory_id"
    t.boolean  "nation_wide",     :default => false
    t.integer  "country_id"
  end

  create_table "stored_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "billing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last4digits"
    t.date     "card_expires_on"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "subcategories", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_counter",                  :default => 0
    t.string   "slug"
    t.integer  "resident_expert_id"
    t.text     "description"
    t.integer  "published_gift_vouchers_count",  :default => 0
    t.integer  "published_special_offers_count", :default => 0
    t.integer  "published_articles_count",       :default => 0
  end

  create_table "subcategories_users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subcategory_id"
    t.integer  "user_id"
    t.integer  "position"
    t.integer  "expertise_position"
    t.integer  "points"
  end

  add_index "subcategories_users", ["expertise_position"], :name => "index_subcategories_users_on_expertise_position"
  add_index "subcategories_users", ["subcategory_id"], :name => "index_subcategories_users_on_subcategory_id"
  add_index "subcategories_users", ["user_id"], :name => "index_subcategories_users_on_user_id"

  create_table "tabs", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "slug"
    t.integer  "subcategory_id"
  end

  add_index "tabs", ["position"], :name => "index_tabs_on_position"
  add_index "tabs", ["user_id"], :name => "index_tabs_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer "taggable_id"
    t.integer "tag_id"
    t.string  "taggable_type"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.datetime "last_run"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_emails", :force => true do |t|
    t.integer  "user_id"
    t.string   "email_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.string   "subject"
    t.text     "body"
    t.integer  "mass_email_id"
    t.integer  "contact_id"
    t.integer  "newsletter_id"
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
    t.integer  "visited_user_id"
    t.integer  "results_found"
    t.string   "what"
    t.string   "where"
    t.string   "browser"
    t.string   "session"
  end

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "state",           :default => "draft"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.text     "reason_reject"
    t.datetime "rejected_at"
    t.integer  "rejected_by_id"
    t.text     "comment_approve"
    t.datetime "approved_at"
    t.integer  "approved_by_id"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name",                          :limit => 100, :default => ""
    t.string   "last_name",                           :limit => 100, :default => ""
    t.string   "email",                               :limit => 100
    t.string   "crypted_password",                    :limit => 40
    t.string   "salt",                                :limit => 40
    t.string   "remember_token",                      :limit => 40
    t.string   "activation_code",                     :limit => 40
    t.string   "state",                                              :default => "passive"
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
    t.boolean  "receive_newsletter",                                 :default => true
    t.boolean  "professional",                                       :default => false
    t.boolean  "free_listing"
    t.string   "business_name"
    t.string   "address1"
    t.string   "suburb"
    t.string   "city"
    t.integer  "district_id"
    t.string   "phone"
    t.string   "mobile"
    t.string   "slug"
    t.datetime "member_since"
    t.datetime "member_until"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "new_user",                                           :default => true
    t.integer  "articles_count",                                     :default => 0
    t.integer  "how_tos_count",                                      :default => 0
    t.integer  "special_offers_count",                               :default => 0
    t.integer  "published_articles_count",                           :default => 0
    t.integer  "published_how_tos_count",                            :default => 0
    t.integer  "published_special_offers_count",                     :default => 0
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "resident_since"
    t.datetime "resident_until"
    t.string   "description"
    t.string   "website"
    t.integer  "gift_vouchers_count",                                :default => 0
    t.integer  "published_gift_vouchers_count",                      :default => 0
    t.boolean  "receive_professional_newsletter",                    :default => true
    t.string   "unsubscribe_token"
    t.datetime "last_logged_at"
    t.boolean  "paid_photo",                                         :default => false
    t.boolean  "paid_highlighted",                                   :default => false
    t.integer  "paid_special_offers",                                :default => 0
    t.integer  "paid_gift_vouchers",                                 :default => 0
    t.date     "paid_photo_until"
    t.date     "paid_highlighted_until"
    t.date     "paid_gift_vouchers_next_date_check"
    t.date     "paid_special_offers_next_date_check"
    t.datetime "feature_warning_sent"
    t.boolean  "notify_unpublished"
    t.string   "subdomain"
    t.datetime "offers_reminder_sent_at"
    t.string   "about",                               :limit => 600
    t.integer  "country_id"
    t.boolean  "homepage_featured",                                  :default => false
    t.datetime "last_homepage_featured_at"
    t.boolean  "is_resident_expert"
    t.string   "expertise_description"
    t.string   "resident_expertise_description"
    t.boolean  "homepage_featured_resident"
    t.datetime "last_homepage_featured_resident_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["state"], :name => "index_users_on_state"

end
