class Counter < ActiveRecord::Base
  named_scope :published, :conditions => ["state= 'published'"] 
end
