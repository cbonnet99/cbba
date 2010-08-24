class ArticlesBlogSubcategory < ActiveRecord::Base
	belongs_to :article
	belongs_to :blog_subcategory
end
