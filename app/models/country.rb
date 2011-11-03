class Country < ActiveRecord::Base
  has_many :users
  has_many :articles
  has_many :contacts
  has_many :counters
  has_many :districts 
  has_many :gift_vouchers, :order => "title"
  has_many :how_tos
  has_many :regions
  has_many :special_offers, :order => "title" 
  has_many :countries_subcategories
  has_many :js_counters
  has_many :subcategories_users, :through => :users 
  has_many :questions
  
  named_scope :active, :conditions => "active is true"
  
  def self.extract_country_code_from_host(host)
    host_bits = host.split(".")
    subdomain = host_bits[0]
    @country = Country.find_by_country_code(subdomain)
    if @country.nil?
      @country = Country.default_country
    end
    return @country    
  end
    
  def to_s
    "#{self.id}: #{self.name}"
  end

  def featured_full_members
    User.find(:all, :include => "user_profile", :conditions => ["user_profiles.state = 'published' and users.country_id = ? and paid_photo is true and free_listing is false and users.state='active'", self.id], :order => "last_homepage_featured_at", :limit => User::NUMBER_HOMEPAGE_FEATURED_USERS)
  end

  
  def self.default_country
    Country.find_by_default_country(true)
  end
end
