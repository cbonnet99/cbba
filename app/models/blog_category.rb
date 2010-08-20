class BlogCategory < ActiveRecord::Base
  has_many :subcategories
end
