class ArticlesDigest < ActiveRecord::Base
  belongs_to :news_digest
  belongs_to :article
end
