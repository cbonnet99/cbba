ActiveRecord::Schema.define(:version => 0) do
    
  create_table "events", :force => true do |t|
    t.string   "source_url"
    t.string   "destination_url"
    t.string   "remote_ip"
    t.datetime "logged_at"
    t.text     "extra_data"
    t.string   "event_type"
    t.string   "extra_option"
  end
    
end
