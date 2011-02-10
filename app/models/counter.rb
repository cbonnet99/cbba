class Counter < ActiveRecord::Base

  belongs_to :country

  named_scope :published, :conditions => ["state= 'published'"] 
  
  def controller_name
    class_name.underscore.pluralize.downcase
  end
end
