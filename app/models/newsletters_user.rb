class NewslettersUser < ActiveRecord::Base
  belongs_to :newsletter
  belongs_to :user
end
