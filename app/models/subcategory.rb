class Subcategory < ActiveRecord::Base
	belongs_to :category
	has_many :users
	has_many :articles

	def full_name
		"#{category.name} - #{name}"
	end
end
