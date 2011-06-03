class SubcategoriesCountry < ActiveRecord::Base
  belongs_to :subcategory
  belongs_to :country
end
