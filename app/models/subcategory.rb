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

  named_scope :with_resident_expert, :conditions => "resident_expert_id is not null"
  
  MAX_RESIDENT_EXPERTS_PER_SUBCATEGORY = 3
  
  def resident_experts
    experts = User.find(:all, :include  => "subcategories_users", :conditions => ["subcategories_users.subcategory_id = ? and subcategories_users.points >= ?", self.id, User::MIN_POINTS_TO_QUALIFY_FOR_EXPERT], :order => "subcategories_users.points desc")
    unless experts.blank?
      experts = experts[0..MAX_RESIDENT_EXPERTS_PER_SUBCATEGORY-1]
    end
    experts
  end

  def has_users?
    !users_counter.nil? && users_counter > 0
  end

  def last_articles(number_articles)
    self.articles.published.find(:all, :order => "published_at desc", :limit => number_articles)
  end

  def users_hash_by_region
    res = {}
    self.users.find(:all, :include => [:region, :user_profile],  :order => "regions.name, paid_photo desc, paid_highlighted desc, user_profiles.published_at").each do |u|
      if res[u.region.name].blank?
        res[u.region.name] = [u]
      else
        res[u.region.name] += [u]
      end
    end
    return res
  end

  def default_tab_content(user)
    string = "<h3>About #{self.name}</h3> <p>Give a summary here of your service&nbsp;(Just delete this text and the heading to remove it from your profile)</p> <h3>Key benefits</h3> <div> <ul> <li>List a benefit here (or delete this text)</li> <li>List a benefit here (or delete this text)</li> <li>List a benefit here (or delete this text)</li> </ul> </div> <h3>My Training</h3> <div> <ul> <li>List your training here (or delete this text)</li> <li>List your training here&nbsp;(or delete this text)</li> <li>List your training here&nbsp;(or delete this text)</li> </ul> </div> <h3>What you can expect...</h3> <p>Write about what people can expect from you and your service... (Just delete this text and the heading to remove it from your profile)</p> <h3>About #{user.first_name}</h3> <p>Tell people something about yourself and how you connect with the service... (Just delete this text and the heading to remove it from your profile)</p>"
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
