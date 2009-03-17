class GiftVoucher < ActiveRecord::Base
  include Workflowable
  
  belongs_to :author, :class_name => "User", :counter_cache => true
  
  after_create :create_slug

  validates_presence_of :title, :description
  validates_uniqueness_of :title, :scope => "author_id"

  MAX_PUBLISHED = {:full_member => 1, :resident_expert => 3 }

  def to_param
    slug
  end
  
	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		title.parameterize
	end
end
