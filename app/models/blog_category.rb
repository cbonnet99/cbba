class BlogCategory < ActiveRecord::Base
  include Sluggable

  has_many :blog_subcategories
  has_many :articles_blog_categories
  has_many :articles, :through => :articles_blog_categories 
  has_many :blog_categories_questions
  has_many :questions, :through => :blog_categories_questions
  
  def self.random
    BlogCategory.find(rand(BlogCategory.count)+1)
  end
end
