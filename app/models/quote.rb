class Quote < ActiveRecord::Base
  
  named_scope :homepage_featured, :conditions => ["homepage_featured is true"] 
  
  def self.rotate_featured
    quote_to_feature = Quote.find(:first, :conditions => ["last_homepage_featured_at is NULL"])
    if quote_to_feature.nil?
      quote_to_feature = Quote.find(:first, :order => "last_homepage_featured_at")
    end
    Quote.homepage_featured.each {|q| q.update_attribute(:homepage_featured, false)}
    quote_to_feature.homepage_featured = true
    quote_to_feature.last_homepage_featured_at = Time.now
    quote_to_feature.save!    
  end
end
