class Charity < ActiveRecord::Base
  has_many :payments
end
