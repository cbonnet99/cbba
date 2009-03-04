class Region < ActiveRecord::Base
  has_many :users
	has_many :districts
  after_create :create_slug

  def self.from_param(param)
    unless param.blank?
      return find(:first, :conditions => ["lower(name) = ?", param.downcase])
    end
  end
  
  def to_param
    slug
  end

	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		name.parameterize
	end
end
