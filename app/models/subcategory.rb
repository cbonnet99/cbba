class Subcategory < ActiveRecord::Base
	belongs_to :category
	has_many :subcategories_users, :order => "position"
	has_many :users, :through => :subcategories_user
	has_many :articles

  validates_uniqueness_of :name, :scope => [:category_id], :message => "must be unique in this category"
  after_create :create_slug

  def to_param
    slug
  end

	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		name.parameterize
	end

	def self.options(category, selected_subcategory_id=nil)
		Subcategory.find_all_by_category_id(category.id,  :order => "name").inject("<option value=''>All #{category.name}</option>"){|memo, subcat|
			if !selected_subcategory_id.nil? && selected_subcategory_id == subcat.id
				memo << "<option value='#{subcat.id}' selected='selected'>#{subcat.name}</option>"
			else
				memo << "<option value='#{subcat.id}'>#{subcat.name}</option>"
			end
		}
	end

	def full_name
		"#{category.name} - #{name}"
	end
end
