class GiftVoucher < ActiveRecord::Base
  include Workflowable
  include Sluggable

  belongs_to :author, :class_name => "User", :counter_cache => true
  belongs_to :subcategory
  has_many :gift_vouchers_newsletters
  has_many :newsletters, :through => :gift_vouchers_newsletters 
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title, :scope => "author_id", :message => "is already used for another of your gift vouchers" 

  def short_description
    if description.nil?
      ""
    else
      description[0..300]
    end
  end
	
	def self.count_published_gift_vouchers
	  GiftVoucher.find_all_by_state("published").size
  end
		
end
