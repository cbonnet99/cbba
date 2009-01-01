class HowTosSubcategory < ActiveRecord::Base
	belongs_to :how_to
	belongs_to :subcategory
end