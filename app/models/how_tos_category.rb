class HowTosCategory < ActiveRecord::Base
	belongs_to :how_to
	belongs_to :category
end