class Category < ActiveRecord::Base

	acts_as_list

	has_many :subcategories, :order => "name"
	validates_uniqueness_of :name

	def self.list_categories
		Category.find(:all, :order => "position, name" )
	end

end
