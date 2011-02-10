class Country < ActiveRecord::Base
  has_many :users
  has_many :articles
  has_many :contacts
  has_many :counters
  has_many :districts
  has_many :gift_vouchers
  has_many :how_tos
  has_many :regions
  has_many :special_offers
end
