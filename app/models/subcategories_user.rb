class SubcategoriesUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :subcategory
  acts_as_list :scope => :user, :column => "expertise_position"
end