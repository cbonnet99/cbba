class Category < ActiveRecord::Base

  include Sluggable

	acts_as_list

	has_many :categories_users, :order => "position"
	has_many :users, :through => :categories_users
	has_many :subcategories, :order => "name"
	validates_uniqueness_of :name

  def self.from_param(param)
    unless param.blank?
      return find(:first, :conditions => ["lower(name) = ?", param.downcase])
    end
  end
  
	def self.list_categories
		Category.find(:all, :order => "position, name" )
	end

  def user_count_for_country(country)
    cc = CategoriesCountry.find_by_category_id_and_country_id(self.id, country.id)
    if cc.nil?
      return 0
    else
      return cc.count
    end
  end

end
