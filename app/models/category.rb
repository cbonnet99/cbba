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

end
