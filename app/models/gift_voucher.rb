class GiftVoucher < ActiveRecord::Base
  include Workflowable
  include Sluggable

  belongs_to :author, :class_name => "User", :counter_cache => true
  belongs_to :subcategory
  has_many :gift_vouchers_newsletters
  has_many :newsletters, :through => :gift_vouchers_newsletters 
  belongs_to :country
  
  validates_presence_of :title, :description
  validates_length_of :description, :maximum => 600
  validates_uniqueness_of :title, :scope => "author_id", :message => "is already used for another of your gift vouchers" 
  
  def summary
    short_description
  end
  
  def short_description
    if description.nil?
      ""
    else
      description[0..300]
    end
  end
	
	def self.count_published(country)
	  GiftVoucher.count(:all, :conditions => ["state = ? and country_id = ?", 'published', country.id])
  end
		
end
