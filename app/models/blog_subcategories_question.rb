class BlogSubcategoriesQuestion < ActiveRecord::Base
  belongs_to :blog_subcategory
  belongs_to :question
end
