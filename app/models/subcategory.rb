class Subcategory < ActiveRecord::Base

  include Sluggable

	belongs_to :category
	has_many :subcategories_users, :order => "position", :dependent => :delete_all 
	has_many :users, :through => :subcategories_users
	has_many :articles_subcategories, :dependent => :delete_all 
	has_many :articles, :through => :articles_subcategories, :order => "published_at desc" 
	has_many :special_offers
	has_many :gift_vouchers
  has_many :tabs
  belongs_to :resident_expert, :class_name => "User"
  has_many :countries_subcategories
  
  validates_presence_of :name
  validates_uniqueness_of :name, :message => "must be unique"

  named_scope :with_resident_expert, :conditions => "resident_expert_id is not null", :order => "name"
  
  MAX_RESIDENT_EXPERTS_PER_SUBCATEGORY = 3

  def published_special_offers_count(country)
    country.special_offers.count(:all, :conditions => ["state = 'published' and subcategory_id = ?", self.id])
  end

  def published_gift_vouchers_count(country)
    country.gift_vouchers.count(:all, :conditions => ["state = 'published' and subcategory_id = ?", self.id])
  end

  def published_articles_count(country)
    country.articles.count(:all, :include => "articles_subcategories",  :conditions => ["state = 'published' and articles_subcategories.subcategory_id = ?", self.id])
  end
  
  def self.with_articles(country)
    if country.nil?
      return Subcategory.find(:all, :include => "countries_subcategories", :conditions => ["countries_subcategories.published_articles_count > 0"])
    else
      return Subcategory.find(:all, :include => "countries_subcategories", :conditions => ["countries_subcategories.published_articles_count > 0 and country_id = ?", country.id])
    end
  end  
  
  def self.with_special_offers(country)
    Subcategory.find(:all, :include => "countries_subcategories", :conditions => ["countries_subcategories.published_special_offers_count > 0 and countries_subcategories.country_id = ?", country.id])
  end
  
  def self.with_gift_vouchers(country)
    Subcategory.find(:all, :include => "countries_subcategories", :conditions => ["countries_subcategories.published_gift_vouchers_count > 0 and countries_subcategories.country_id = ?", country.id])
  end
  
  def user_count_for_country(country)
    sc = SubcategoriesCountry.find_by_subcategory_id_and_country_id(self.id, country.id)
    if sc.nil?
      return 0
    else
      return sc.count
    end    
  end
  
  def self.last_created_at
    self.first(:order=>"created_at DESC", :conditions=>"created_at IS NOT NULL").try(:created_at)
  end
  
  def self.last_subcat_or_member_created_at(country)
    [UserProfile.last_published_at(country), Subcategory.last_created_at].reject{|stuff| stuff.nil?}.max
  end

  def resident_experts(country)
    return User.find(:all, :include  => "subcategories_users", :conditions => ["subcategories_users.subcategory_id = ? and users.country_id = ? and users.state = 'active' and subcategories_users.points > 0", self.id, country.id], :limit => MAX_RESIDENT_EXPERTS_PER_SUBCATEGORY, :order => "subcategories_users.points desc")
  end

  def users_with_points
    @users_with_points ||= User.find(:all, :include  => "subcategories_users", :conditions => ["subcategories_users.subcategory_id = ? and subcategories_users.points > 0", self.id], :order => "subcategories_users.points desc")
  end

  def has_users?
    !users_counter.nil? && users_counter > 0
  end

  def last_articles(number_articles)
    self.articles.published.find(:all, :order => "published_at desc", :limit => number_articles)
  end

  def users_hash_by_region(country)
    res = {}
    self.users.active.find(:all, :conditions => ["users.country_id = ?", country.id], :include => [:region, :user_profile],  :order => "regions.name, paid_photo desc, paid_highlighted desc, user_profiles.published_at").each do |u|
      if res[u.region.name].blank?
        res[u.region.name] = [u]
      else
        res[u.region.name] += [u]
      end
    end
    return res
  end

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
