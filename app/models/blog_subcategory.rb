class BlogSubcategory < ActiveRecord::Base
  include Sluggable

  belongs_to :blog_category
  has_many :articles_blog_subcategories
  has_many :articles, :through => :articles_blog_subcategories, :order => "published_at desc" 
  has_many :blog_subcategories_questions
  has_many :questions, :through => :blog_subcategories_questions, :order => "published_at desc" 
  
	def full_name
		"#{blog_category.try(:name)} - #{name}"
	end
  
end
