class Counter < ActiveRecord::Base
  named_scope :published, :conditions => ["state= 'published'"] 
  
  def controller_name
    title.gsub(/ /, '_').downcase
  end
end
