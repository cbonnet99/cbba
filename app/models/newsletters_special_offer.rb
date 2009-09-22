class NewslettersSpecialOffer < ActiveRecord::Base
  belongs_to :special_offer
  belongs_to :newsletter
end
