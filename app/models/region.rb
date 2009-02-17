class Region < ActiveRecord::Base
  has_many :users
	has_many :districts
  after_create :create_slug

  def self.from_param(param)
    unless param.blank?
      return find_by_name(param)
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
