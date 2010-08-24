class BlogSubcategory < ActiveRecord::Base
  belongs_to :blog_category
  has_many :articles_blog_subcategories
  
	def full_name
		"#{blog_category.try(:name)} - #{name}"
	end
  
end
