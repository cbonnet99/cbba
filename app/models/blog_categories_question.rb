class BlogCategoriesQuestion < ActiveRecord::Base
  belongs_to :blog_category
  belongs_to :question
end
