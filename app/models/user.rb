require File.dirname(__FILE__) + '/../../lib/helpers'
require 'digest/sha1'

class User < ActiveRecord::Base
  include Slugalizer
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
	include SubcategoriesSystem
	
  has_attached_file :photo, :styles => { :medium => "200x250>", :thumbnail => "100x125>" },
                            :url  => "/assets/profiles/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/assets/profiles/:id/:style/:basename.:extension"
                           
  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :email, :first_name, :last_name
  validates_presence_of :district, :message => "^Your area can't be blank"
  validates_length_of :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD
  validates_attachment_size :photo, :less_than => 3.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
	# Relationships

  has_many :roles_users
  has_many :roles, :through => :roles_users, :uniq => true 
  belongs_to :region
  belongs_to :district
  has_many :articles
  has_many :approved_articles, :class_name => "articles"
  has_many :rejected_articles, :class_name => "articles"
	has_many :subcategories_users
	has_many :subcategories, :through => :subcategories_users
	has_many :categories_users
	has_many :categories, :through => :categories_users
  has_many :tabs, :order => "position"
  has_one :user_profile
  
	# #around filters
	before_create :assemble_phone_numbers, :get_region_from_district, :get_membership_type
	before_update :assemble_phone_numbers, :get_region_from_district, :get_membership_type

  after_create :create_slug, :create_profile

	# HACK HACK HACK -- how to do attr_accessible from here? prevents a user from
	# submitting a crafted form that bypasses activation anything else you want
	# your user to change should be added here.
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :receive_newsletter, :professional, :address1, :address2, :district_id, :region_id, :mobile, :mobile_prefix, :mobile_suffix, :phone, :phone_prefix, :phone_suffix, :subcategory1_id, :subcategory2_id, :subcategory3_id, :free_listing, :business_name, :suburb, :city, :membership_type, :photo
	attr_accessor :membership_type
  attr_writer :mobile_prefix, :mobile_suffix, :phone_prefix, :phone_suffix

  def select_tab(tab_slug)
    if tab_slug.nil?
      tabs.first
    else
      if tab_slug == Tab::ARTICLES
        virtual_tab = VirtualTab.new(Tab::ARTICLES, "Articles", "articles/index" )
        puts "========= virtual_tab: #{virtual_tab.inspect}"
        return virtual_tab
      else
        tabs.find_by_slug(tab_slug) || tabs.first
      end
    end
  end

  def admin?
    has_role?("admin")
  end

  def full_member?
    has_role?("full_member")
  end

  def sentence_to_review
    total = $workflowable_stuff.inject(0) {|sum, stuff| sum +=Kernel.const_get(stuff).count_reviewable}
    help.pluralize(total, "item") << " to review"
  end

  def create_profile
    UserProfile.create(:user_id => self.id)
  end

  def add_role(role_string)
    role = Role.find_by_name(role_string)
    unless role.nil? || has_role?(role_string)
      self.roles << role
    end
  end

  def add_tabs
    unless free_listing?
      subcategories.each do |s|
        self.add_tab(s.name, s.name)
      end
       self.add_tab("About #{first_name}", "About #{first_name}")
    end
  end

  def to_param
     slug
  end

	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		Slugalizer.slugalize(full_name)

	end

  def phone_prefix
    @phone_prefix ||
    (unless phone.blank?
      phone_bits = phone.split("-")
      phone_bits.first
    end)
  end

  def phone_suffix
    @phone_suffix ||
    (unless phone.blank?
      phone_bits = phone.split("-")
      if phone_bits.size > 1
        phone_bits.last
      else
        ""
      end
    end)
  end

  def mobile_prefix
    @mobile_prefix ||
    (unless mobile.blank?
      mobile_bits = mobile.split("-")
      mobile_bits.first
    end)
  end

  def mobile_suffix
    @mobile_suffix ||
    (unless mobile.blank?
      mobile_bits = mobile.split("-")
      if mobile_bits.size > 1
        mobile_bits.last
      else
        ""
      end
    end)
  end

  #describes subcategories in a sentence
  def expertise
    subcategories.map(&:name).to_sentence
  end

  def add_tab(title, content)
    Tab.create(:user_id => id, :title => title, :content => content )
  end

  def remove_tab(tab_slug)
    tab = self.tabs.find_by_slug(tab_slug)
    unless tab.nil?
      tab.destroy
    end
  end

  def set_membership_type
    if free_listing?
      self.membership_type = "free_listing"
    end
    if full_member?
      self.membership_type = "full_member"
    end
  end
  def get_membership_type
    case membership_type
    when "full_member"
      self.free_listing=false
      self.member_since = Time.now.utc
      self.member_until = 1.year.from_now
      add_tabs
      unless full_member?
        self.add_role("full_member")
      end
    else
      self.free_listing=true
      unless has_role?("free_listing")
        self.add_role("free_listing")
      end
    end
    #!IMPORTANT: always return true in an around filter: see http://www.dansketcher.com/2006/12/30/activerecordrecordnotsaved-before_save-problem/
    return true
  end

	def full_name
		res = name
		unless business_name.blank? || business_name == name
			res << " - #{business_name}"
		end
		return res
	end

	def self.reviewers
		User.find_by_sql("select u.* from users u, roles r, roles_users ru where u.id = ru.user_id and ru.role_id = r.id and r.name='reviewer'")
	end

	def self.find_all_by_region_and_subcategories(region, *subcategories)
		User.find_by_sql(["select u.* from users u, subcategories_users su where u.state='active' and u.id = su.user_id and u.region_id = ? and su.subcategory_id in (?) order by free_listing, su.position", region.id, subcategories])
	end

	def self.find_all_by_subcategories(*subcategories)
		User.find_by_sql(["select u.* from users u, subcategories_users su where u.state='active' and u.id = su.user_id and su.subcategory_id in (?) order by free_listing, su.position", subcategories])
	end

	def self.count_all_by_subcategories(*subcategories)
		User.count_by_sql(["select count(u.*) as count from users u, subcategories_users su where u.state='active' and u.id = su.user_id and su.subcategory_id in (?)", subcategories])
	end

	def self.search_results(category_id, subcategory_id, region_id, district_id, page)
		if subcategory_id.nil?
			if district_id.nil?
				User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r, categories_users cu where u.state='active' and cu.user_id = u.id and cu.category_id = ? and u.region_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing, cu.position", category_id, region_id], :page => page, :per_page => $search_results_per_page )
			else
				User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r, categories_users cu where u.state='active' and cu.user_id = u.id and cu.category_id = ? and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing, cu.position", category_id, district_id], :page => page, :per_page => $search_results_per_page )
			end
		else
			if district_id.nil?
				User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where u.state='active' and su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and u.region_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing, su.position", subcategory_id, region_id],  :page => page, :per_page => $search_results_per_page )
			else
				User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where u.state='active' and su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing, su.position", subcategory_id, district_id], :page => page, :per_page => $search_results_per_page )
			end
		end
	end

	def get_region_from_district
		unless self.district.nil?
			self.region = self.district.region
		end
	end

	def assemble_phone_numbers
			self.mobile = "#{mobile_prefix}-#{mobile_suffix}"
			self.phone = "#{self.phone_prefix}-#{self.phone_suffix}"
	end

  def disassemble_phone_numbers
    unless phone.blank? && !phone.include?("-")
      phone_bits = phone.split("-")
      self.phone_prefix = phone_bits.first
      self.phone_suffix = phone_bits.last
    end
    unless mobile.blank? && !mobile.include?("-")
      mobile_bits = mobile.split("-")
      self.mobile_prefix = mobile_bits.first
      self.mobile_suffix = mobile_bits.last
    end
  end

	def validate
    if subcategory1_id.nil? && subcategory2_id.nil? && subcategory3_id.nil?
      errors.add(:subcategory1_id, "^You must select at least one category")
    end
		if professional?
      #combining name and business name must produce a unique string
      # so that we can slug it
			if business_name.blank?
        duplicate_users_count = User.count_by_sql(["select count(u.*) as count from users u where first_name = ? and last_name = ?", first_name, last_name])
        if duplicate_users_count > 1
          errors.add(:first_name, "^There is already a user with the same name. Please enter a business name to differentiate yourself or change your name (by adding a middle name, for instance)")
        end
      else
        duplicate_users_count = User.count_by_sql(["select count(u.*) as count from users u where business_name = ? and first_name = ? and last_name = ?", business_name, first_name, last_name])
        if duplicate_users_count > 1
          errors.add(:business_name, "^There is already a user with the same name and business name")
        end
			end
		end
	end

	# Authenticates a user by their login name and unencrypted password.  Returns
	# the user or nil.
	#
	# uff.  this is really an authorization, not authentication routine. We really
	# need a Dispatch Chain here or something. This will also let us return a human
	# error message.
	#
  def self.authenticate(email, password)
    u = find_in_state :first, :active, :conditions => { :email => email } # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
	# Check if a user has a role.
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end

  def name
    "#{first_name.nil? ? "" : first_name.capitalize} #{last_name.nil? ? "" : last_name.capitalize}"
  end
  
protected

  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
end
