class Subcategory < ActiveRecord::Base
	belongs_to :category
	has_many :subcategories_user
	has_many :users, :through => :subcategories_user
	has_many :articles

	def validate
		unless Subcategory.find_by_category_id_and_name(category_id, name).nil?
			errors.add(:name, "must be unique in this category")
		end
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
