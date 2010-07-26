class Subcategory < ActiveRecord::Base

  include Sluggable

	belongs_to :category
	has_many :subcategories_users, :order => "position", :dependent => :delete_all 
	has_many :users, :through => :subcategories_users
	has_many :articles_subcategories, :dependent => :delete_all 
	has_many :articles, :through => :articles_subcategories
	has_many :special_offers
	has_many :gift_vouchers
  has_many :expert_applications
  belongs_to :resident_expert, :class_name => "User"
  
  validates_presence_of :name
  validates_uniqueness_of :name, :message => "must be unique"

  named_scope :with_articles, :conditions => "published_articles_count > 0", :order => "name"
  named_scope :with_resident_expert, :conditions => "resident_expert_id is not null", :order => "name"
  named_scope :with_special_offers, :conditions => "published_special_offers_count > 0", :order => "name"
  named_scope :with_gift_vouchers, :conditions => "published_gift_vouchers_count > 0", :order => "name"
  
  MAX_RESIDENT_EXPERTS_PER_SUBCATEGORY = 3
  
  def self.last_created_at
    self.first(:order=>"created_at DESC", :conditions=>"created_at IS NOT NULL").try(:created_at)
  end
  
  def self.last_subcat_or_member_created_at
    [UserProfile.last_published_at, Subcategory.last_created_at].max
  end

  def self.find_and_cache_expert_subcats
    subcats = Subcategory.find(:all, :include => "subcategories_users", :conditions => ["subcategories_users.points >= ?", User::MIN_POINTS_TO_QUALIFY_FOR_EXPERT], :order => "name, subcategories_users.points desc")
    encoded_subcats = subcats.inject(""){|str, s| str << "#{s.id}/" }
    Rails.cache.write("subcats_with_experts", encoded_subcats)
    return subcats  
  end
  
  def has_resident_experts?
    encoded_subcats = Rails.cache.read("subcats_with_experts")
    if encoded_subcats.blank?
      subcats = Subcategory.find_and_cache_expert_subcats
      return subcats.include?(self)
    else
      return encoded_subcats.split("/").include?(self.id.to_s)
    end
  end
  
  def resident_experts
    encoded_experts = Rails.cache.read("experts_in_subcats")
    if encoded_experts.blank?
      experts = User.find(:all, :include  => "subcategories_users", :conditions => ["subcategories_users.subcategory_id = ? and subcategories_users.points >= ?", self.id, User::MIN_POINTS_TO_QUALIFY_FOR_EXPERT], :order => "subcategories_users.points desc")
      unless experts.blank?
        experts = experts[0..MAX_RESIDENT_EXPERTS_PER_SUBCATEGORY-1]
      end
    else
      experts_for_subcat = encoded_experts.split("/").select{|str| str.split(":")[0] == self.id.to_s}
      experts = []
      unless experts_for_subcat.blank?
        experts_for_subcat.each{|str| str.split(":")[1].split(",").each{|res_id| experts << User.find(res_id)}}
      end
    end
    experts
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

  def users_hash_by_region
    res = {}
    self.users.active.find(:all, :include => [:region, :user_profile],  :order => "regions.name, paid_photo desc, paid_highlighted desc, user_profiles.published_at").each do |u|
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
