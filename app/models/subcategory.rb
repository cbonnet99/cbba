class Subcategory < ActiveRecord::Base

  include Sluggable

	belongs_to :category
	has_many :subcategories_users, :order => "position"
	has_many :users, :through => :subcategories_users
	has_many :articles
	has_many :special_offers
	has_many :gift_vouchers
  has_many :expert_applications
  belongs_to :resident_expert, :class_name => "User"

  validates_uniqueness_of :name, :scope => [:category_id], :message => "must be unique in this category"

  named_scope :with_resident_expert, :conditions => "resident_expert_id is not null"

  def self.from_param(param)
    unless param.blank?
      return find(:first, :conditions => ["lower(name) = ?", param.downcase])
    end
  end

	def self.options(category, selected_subcategory_id=nil)
		Subcategory.find_all_by_category_id(category.id,  :order => "name").inject("<option value=''>All #{category.name}</option>"){|memo, subcat|
			if !selected_subcategory_id.nil? && selected_subcategory_id == subcat.id
				memo << "<option value='#{subcat.id}' selected='selected'>#{subcat.name}</option>"
			else
				memo << "<option value='#{subcat.id}'>#{subcat.name}</option>"
			end
		}
	end

	def full_name
		"#{category.name} - #{name}"
	end
end
