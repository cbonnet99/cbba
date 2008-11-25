require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :email, :district
  validates_length_of :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD
  
	# Relationships
  has_many :roles_users
  has_many :roles, :through => :roles_users
  belongs_to :region
  belongs_to :district
  has_many :articles
	has_many :subcategories_user
	has_many :subcategories, :through => :subcategories_user

	# #around filters
	before_create :assemble_phone_numbers, :set_region_from_district
	before_update :assemble_phone_numbers, :set_region_from_district
	after_create :save_subcategories
	after_update :save_subcategories

	# HACK HACK HACK -- how to do attr_accessible from here? prevents a user from
	# submitting a crafted form that bypasses activation anything else you want
	# your user to change should be added here.
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :receive_newsletter, :professional, :address1, :address2, :district_id, :region_id, :mobile, :mobile_prefix, :mobile_suffix, :phone, :phone_prefix, :phone_suffix, :subcategory1_id, :subcategory2_id, :subcategory3_id, :free_listing, :business_name, :suburb
	attr_accessor :mobile_prefix, :mobile_suffix, :phone_prefix, :phone_suffix, :subcategory1_id, :subcategory2_id, :subcategory3_id

	def self.find_all_by_region_and_subcategories(region, *subcategories)
		User.find_by_sql(["select u.* from users u, subcategories_users su where u.id = su.user_id and u.region_id = ? and su.subcategory_id in (?)", region.id, subcategories])
	end

	def self.find_all_by_subcategories(*subcategories)
		User.find_by_sql(["select u.* from users u, subcategories_users su where u.id = su.user_id and su.subcategory_id in (?)", subcategories])
	end

	def self.count_all_by_subcategories(*subcategories)
		User.count_by_sql(["select count(u.*) as count from users u, subcategories_users su where u.id = su.user_id and su.subcategory_id in (?)", subcategories])
	end

	def save_subcategories
		self.subcategories.destroy_all
		unless subcategory1_id.nil?
			sub1 = Subcategory.find(subcategory1_id)
			self.subcategories << sub1
		end
		unless subcategory2_id.nil?
			sub2 = Subcategory.find(subcategory2_id)
			self.subcategories << sub2
		end
		unless subcategory3_id.nil?
			sub3 = Subcategory.find(subcategory3_id)
			self.subcategories << sub3
		end
	end

	def self.search_results(category_id, subcategory_id, region_id, district_id, page)
		if subcategory_id.nil?
			if district_id.nil?
				User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where s.category_id = ? and su.subcategory_id = s.id and su.user_id = u.id and u.region_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing", category_id, region_id], :page => page, :per_page => $search_results_per_page )
			else
				User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where s.category_id = ? and su.subcategory_id = s.id and su.user_id = u.id and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing", category_id, district_id], :page => page, :per_page => $search_results_per_page )
			end
		else
			if district_id.nil?
				User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and u.region_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing", subcategory_id, region_id], :page => page, :per_page => $search_results_per_page )
			else
				User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing", subcategory_id, district_id], :page => page, :per_page => $search_results_per_page )
			end
		end
	end

	def set_region_from_district
		unless self.district.nil?
			self.region = self.district.region
		end
	end

	def assemble_phone_numbers
		if mobile.blank?
			self.mobile = "#{mobile_prefix}-#{mobile_suffix}"
		end
		if phone.blank?
			self.phone = "#{phone_prefix}-#{phone_suffix}"
		end
	end

	def validate
		if professional? && free_listing?
			if business_name.blank?
				errors.add(:business_name, "can't be blank")
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
