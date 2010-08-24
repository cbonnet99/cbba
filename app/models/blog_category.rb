class BlogCategory < ActiveRecord::Base
  has_many :blog_subcategories
  has_many :articles_blog_categories
end
