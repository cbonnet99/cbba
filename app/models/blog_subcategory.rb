class BlogSubcategory < ActiveRecord::Base
  belongs_to :blog_category
end
