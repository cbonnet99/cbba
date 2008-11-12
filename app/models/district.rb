class District < ActiveRecord::Base
  has_many :users
	belongs_to :region
end
