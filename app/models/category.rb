class Category < ActiveRecord::Base

	acts_as_list

	has_many :subcategories, :order => "name"
	validates_uniqueness_of :name
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

	def self.list_categories
		Category.find(:all, :order => "position, name" )
	end

end
