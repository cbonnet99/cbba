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
	belongs_to :subcategory1, :class_name => "Subcategory"
	belongs_to :subcategory2, :class_name => "Subcategory"
	belongs_to :subcategory3, :class_name => "Subcategory"

	# #around filters
	before_create :assemble_phone_numbers, :set_region_from_district
	before_update :assemble_phone_numbers, :set_region_from_district

	# HACK HACK HACK -- how to do attr_accessible from here? prevents a user from
	# submitting a crafted form that bypasses activation anything else you want
	# your user to change should be added here.
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :receive_newsletter, :professional, :address1, :address2, :district_id, :region_id, :mobile, :mobile_prefix, :mobile_suffix, :phone, :phone_prefix, :phone_suffix, :subcategory1_id, :subcategory2_id, :subcategory3_id, :free_listing, :business_name, :suburb
	attr_accessor :mobile_prefix, :mobile_suffix, :phone_prefix, :phone_suffix

	def self.search_results(category_id, subcategory_id, region_id, district_id)
		if subcategory_id.nil?
			if district_id.nil?
				User.find_by_sql(["select distinct u.* from users u, roles_users ru, subcategories s, roles r where s.category_id = ? and (u.subcategory1_id = s.id or u.subcategory2_id = s.id or u.subcategory3_id = s.id) and u.region_id = ? and (u.free_listing is true or (r.name='full_member' and r.id = ru.role_id and ru.user_id=u.id)) order by free_listing", category_id, region_id])
			else
				User.find_by_sql(["select distinct u.* from users u, roles_users ru, subcategories s, roles r where s.category_id = ? and (u.subcategory1_id = s.id or u.subcategory2_id = s.id or u.subcategory3_id = s.id) and u.district_id = ? and (u.free_listing is true or (r.name='full_member' and r.id = ru.role_id and ru.user_id=u.id)) order by free_listing", category_id, district_id])
			end
		else
			if district_id.nil?
				User.find_by_sql(["select distinct u.* from users u, roles_users ru, subcategories s, roles r where (u.subcategory1_id = s.id or u.subcategory2_id = s.id or u.subcategory3_id = s.id) and s.id = ? and u.region_id = ? and (u.free_listing is true or (r.name='full_member' and r.id = ru.role_id and ru.user_id=u.id)) order by free_listing", subcategory_id, region_id])
			else
				User.find_by_sql(["select distinct u.* from users u, roles_users ru, subcategories s, roles r where (u.subcategory1_id = s.id or u.subcategory2_id = s.id or u.subcategory3_id = s.id) and s.id = ? and u.district_id = ? and (u.free_listing is true or (r.name='full_member' and r.id = ru.role_id and ru.user_id=u.id)) order by free_listing", subcategory_id, district_id])
			end
		end
	end

	def set_region_from_district
		unless self.district.nil?
			self.region = self.district.region
		end
	end

	def assemble_phone_numbers
		self.mobile = "#{mobile_prefix}-#{mobile_suffix}"
		self.phone = "#{phone_prefix}-#{phone_suffix}"
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
