class SubcategoriesUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :subcategory

  acts_as_list :scope => :subcategory, :conditions => "free_listing is false"
end