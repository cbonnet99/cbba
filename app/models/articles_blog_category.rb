class ArticlesBlogCategory < ActiveRecord::Base
  belongs_to :article
  belongs_to :blog_category
end
