class District < ActiveRecord::Base
  has_many :users
	belongs_to :region

	def full_name
		"#{region.name} - #{name}"
	end
end
