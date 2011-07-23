class SubcategoriesUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :subcategory
  
  
  def to_s
    "#{user.name} in #{subcategory.name}[#{expertise_position.nil? ? 'NIL' : expertise_position}]"
  end
end