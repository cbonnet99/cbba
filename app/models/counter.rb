class Counter < ActiveRecord::Base
  named_scope :published, :conditions => ["state= 'published'"] 

  def controller_name
    title.gsub(/ /, '_').downcase
  end
  
  def action_name
    if (controller_name+"_controller").classify.constantize.action_methods.include?("index_public")
      "index_public"
    else
      "index"
    end
  end
end
