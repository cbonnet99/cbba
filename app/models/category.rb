class Category < ActiveRecord::Base

	acts_as_list

	has_many :subcategories

	def self.list_categories
		Category.find(:all, :order => "position, name" )
	end

end
