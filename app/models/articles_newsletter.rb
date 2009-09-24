class ArticlesNewsletter < ActiveRecord::Base
  belongs_to :newsletter
  belongs_to :article
end
