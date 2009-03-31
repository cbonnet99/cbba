require File.dirname(__FILE__) + '/../../lib/helpers'
require 'digest/sha1'

class User < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
  include ContactSystem
	include SubcategoriesSystem
	
  has_attached_file :photo, :styles => { :medium => "200x250>", :thumbnail => "85x100>" },
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
  has_many :messages
  has_many :roles_users
  has_many :roles, :through => :roles_users, :uniq => true 
  belongs_to :region
  belongs_to :district
  has_many :articles, :foreign_key => :author_id
  has_many :how_tos, :foreign_key => :author_id
  has_many :approved_articles, :class_name => "articles"
  has_many :rejected_articles, :class_name => "articles"
	has_many :subcategories_users, :order => "expertise_position"
	has_many :subcategories, :through => :subcategories_users, :include => :subcategories_users, :order => "subcategories_users.expertise_position"
	has_many :categories_users
	has_many :categories, :through => :categories_users
  has_many :tabs, :order => "position"
  has_one :user_profile
  has_many :payments
  has_many :user_emails
  has_many :user_events
  has_many :profile_visits, :class_name => "UserEvent", :foreign_key => :visited_user_id
  has_many :special_offers, :foreign_key => :author_id
  has_many :expert_applications
  has_many :gift_vouchers, :foreign_key => :author_id
  has_one :expertise_subcategory, :class_name => "Subcategory",  :foreign_key => :resident_expert_id

  # #named scopes
  named_scope :wants_newsletter, :conditions => "receive_newsletter is true"
  named_scope :active, :conditions => "state='active'"
  named_scope :free_users, :conditions => "free_listing is true"
  named_scope :paying, :conditions => "free_listing is false"
  named_scope :full_members, :include => "roles", :conditions => "roles.name='full_member'"
  named_scope :reviewers, :include => "roles", :conditions => "roles.name='reviewer'"
  named_scope :admins, :include => "roles", :conditions => "roles.name='admin'"
  named_scope :resident_expert_admins, :include => "roles", :conditions => "roles.name='resident_expert_admin'"
  named_scope :resident_experts, :include => ["roles", "subcategories"], :conditions => "roles.name='resident_expert' and users.id = subcategories.resident_expert_id"
  named_scope :new_users, :conditions => "new_user is true"
  named_scope :geocoded, :conditions => "latitude <> '' and longitude <>''"

  
  # #around filters
	before_create :assemble_phone_numbers, :get_region_from_district, :get_membership_type, :create_slug, :create_geocodes
	before_update :assemble_phone_numbers, :get_region_from_district, :get_membership_type, :create_slug, :update_geocodes

  after_create :create_profile, :add_tabs
  after_update :add_tabs

  # HACK HACK HACK -- how to do attr_accessible from here? prevents a user from
  # submitting a crafted form that bypasses activation anything else you want
  # your user to change should be added here.
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :receive_newsletter, :professional, :address1, :address2, :district_id, :region_id, :mobile, :mobile_prefix, :mobile_suffix, :phone, :phone_prefix, :phone_suffix, :subcategory1_id, :subcategory2_id, :subcategory3_id, :free_listing, :business_name, :suburb, :city, :membership_type, :photo, :latitude, :longitude, :resident_expert_application
	attr_accessor :membership_type, :resident_expert_application
  attr_writer :mobile_prefix, :mobile_suffix, :phone_prefix, :phone_suffix


  def geocoded?
    !latitude.blank? && !longitude.blank?
  end

  def invoices
    Invoice.find_by_sql(["select invoices.* from payments, invoices where payments.user_id = ? and payments.id = invoices.payment_id", self.id])
  end

  def css_class_role_description
    "title-user-#{role_description.downcase.gsub(/ /, '-')}"
  end

  def role_description
    if resident_expert?
      "resident expert"
    else
      if full_member?
        "full member"
      else
        if free_listing?
          "free listing"
        end
      end
    end
  end

  def contact_details
    [address1, suburb, city, phone, mobile].reject{|o| o.blank?||o=="()"}.join("<br/>")

  end

  def max_published_special_offers
    if resident_expert?
      return SpecialOffer::MAX_PUBLISHED[:resident_expert]
    end
    if full_member?
      return SpecialOffer::MAX_PUBLISHED[:full_member]
    end
    return 0
  end

  def max_published_gift_vouchers
    if resident_expert?
      return GiftVoucher::MAX_PUBLISHED[:resident_expert]
    end
    if full_member?
      return GiftVoucher::MAX_PUBLISHED[:full_member]
    end
    return 0
  end

  def create_geocodes
    unless district.blank? || (!latitude.blank? && !longitude.blank?)
      locate_address
    end
  end

  def update_geocodes
    #has any of the location fields changed?
    if self.address1_changed? || self.suburb_changed? || self.district_id_changed?
        locate_address
    end

  end

  def self.map_geocoded(map, users=nil)
    if users.nil?
      users = User.paying.geocoded
    end
    users.each do |u|
      if u.geocoded? && !u.free_listing?
        marker = GMarker.new([u.latitude, u.longitude],
         :title => u.full_name, :info_window => u.full_info)
        map.overlay_init(marker)
      end
    end
  end

  def full_info
    if photo.exists? && user_profile.published?
      res = "<div class='bam-gmarker-photo'><img src='#{photo.url(:thumbnail)}'/></div><div class='bam-gmarker-text'>"
    else
      res = "<div class='bam-gmarker-text'>"
    end
    res << [full_name, main_expertise, address1, suburb, district.name].reject{|o| o.blank?}.join("<br/>")
    res << "<br/>"
    res << [phone, mobile].reject{|o| o.blank? || o == "()"}.join("<br/>")
    res << "</div><div class='cleaner'></div>"
  end

  def no_articles_for_user?(current_user)
    self != current_user && self.articles_count_for_user(current_user) == 0
  end

  def no_special_offers_for_user?(current_user)
    self != current_user && self.special_offers_count_for_user(current_user) == 0
  end

  def no_gift_vouchers_for_user?(current_user)
    self != current_user && self.gift_vouchers_count_for_user(current_user) == 0
  end

  def articles_count_for_user(current_user)
    if current_user == self
      return articles_count + how_tos_count
    else
      return published_articles_count + published_how_tos_count
    end
  end

  def special_offers_count_for_user(current_user)
    if current_user == self
      return special_offers_count
    else
      return published_special_offers_count
    end
  end

  def gift_vouchers_count_for_user(current_user)
    if current_user == self
      return gift_vouchers_count
    else
      return published_gift_vouchers_count
    end
  end

  def default_how_to_book
    str = "Bookings can be made by "
    unless phone.blank? || phone == "()"
      str << "phone or "
    end
    #email cannot be blank
    str << "email:<br/>"
    unless phone.blank? || phone == "()"
      str << phone
      str << "<br/>"
    end
    str << email
  end

  def after_find
    @old_positions = {}
    if self.subcategories_users[0].nil?
      self.subcategory1_id = nil
      old_subcategory1_id = nil
      subcategory1_position = nil
    else
      self.subcategory1_id = self.subcategories_users[0].subcategory_id
      old_subcategory1_id = self.subcategories_users[0].subcategory_id
      subcategory1_position = self.subcategories_users[0].position
      @old_positions[old_subcategory1_id] = subcategory1_position
    end
    if self.subcategories_users[1].nil?
      self.subcategory2_id = nil
      old_subcategory2_id = nil
      subcategory2_position = nil
    else
      self.subcategory2_id = self.subcategories_users[1].subcategory_id
      old_subcategory2_id = self.subcategories_users[1].subcategory_id
      subcategory2_position = self.subcategories_users[1].position
      @old_positions[old_subcategory2_id] = subcategory2_position
    end
    if self.subcategories_users[2].nil?
      self.subcategory3_id = nil
      old_subcategory3_id = nil
      subcategory3_position = nil
    else
      self.subcategory3_id = self.subcategories_users[2].subcategory_id
      old_subcategory3_id = self.subcategories_users[2].subcategory_id
      subcategory3_position = self.subcategories_users[2].position
      @old_positions[old_subcategory3_id] = subcategory3_position
    end

  end

  def save_subcategories
    self.subcategories = []
    self.categories = []
    unless subcategory1_id.blank?
      sub1 = Subcategory.find(self.subcategory1_id)
      self.subcategories << sub1
      unless self.categories.include?(sub1.category)
        self.categories << sub1.category
      end
      # #update expertise position
      unless @old_positions.blank? || @old_positions[self.subcategory1_id].blank?
        su = SubcategoriesUser.find_by_subcategory_id_and_user_id(sub1.id, self.id)
        unless su.nil?
          su.update_attribute(:position, @old_positions[self.subcategory1_id])
        end
      end
    end
    unless subcategory2_id.blank?
      sub2 = Subcategory.find(self.subcategory2_id)
      self.subcategories << sub2
      unless self.categories.include?(sub2.category)
        self.categories << sub2.category
      end
      # #update expertise position
      unless @old_positions.blank? || @old_positions[self.subcategory2_id].blank?
        su = SubcategoriesUser.find_by_subcategory_id_and_user_id(sub2.id, self.id)
        unless su.nil?
          su.update_attribute(:position, @old_positions[self.subcategory2_id])
        end
      end
    end
    unless subcategory3_id.blank?
      sub3 = Subcategory.find(self.subcategory3_id)
      self.subcategories << sub3
      unless self.categories.include?(sub3.category)      
        self.categories << sub3.category
      end
      # #update expertise position
      unless @old_positions.blank? || @old_positions[self.subcategory3_id].blank?
        su = SubcategoriesUser.find_by_subcategory_id_and_user_id(sub3.id, self.id)
        unless su.nil?
          su.update_attribute(:position, @old_positions[self.subcategory3_id])
        end
      end
    end
  end

  def main_expertise_id
    if subcategories.blank?
      ""
    else
      subcategories.first.id
    end
  end
  memoize :main_expertise_id

  def main_expertise
    if subcategories.blank?
      ""
    else
      subcategories.first.name
    end
  end
  memoize :main_expertise

  def main_expertise_slug
    if subcategories.blank?
      ""
    else
      subcategories.first.slug
    end
  end
  memoize :main_expertise_slug

  def region_name
    if region.blank?
      ""
    else
      region.name
    end
  end
  memoize :region_name

  def author?(stuff)
    (self == stuff.author || self.admin?)
  end

  def self.paginated_full_members(page, limit=$full_members_per_page)
    User.paginate(:all, :include => "user_profile", :conditions => "user_profiles.state = 'published' and free_listing is false", :order => "published_at desc", :limit => limit, :page => page )
  end

  def self.newest_full_members
    User.find(:all, :include => "user_profile", :conditions => "user_profiles.state = 'published' and free_listing is false", :order => "published_at desc", :limit => $number_full_members_on_homepage  )
  end

  def self.published_resident_experts
    User.find(:all, :include => ["user_profile", "roles"], :conditions => "roles.name='resident_expert' and user_profiles.state = 'published' and free_listing is false", :order => "first_name, last_name")
  end

  def self.count_published_resident_experts
    User.count(:include => ["user_profile", "roles"], :conditions => "roles.name='resident_expert' and user_profiles.state = 'published' and free_listing is false")
  end

  def self.published_full_members
    User.find(:all, :include => ["user_profile", "roles"], :conditions => "roles.name='full_member' and user_profiles.state = 'published' and free_listing is false", :order => "first_name, last_name")
  end

  def self.count_published_full_members
    User.count(:include => ["user_profile", "roles"], :conditions => "roles.name='full_member' and user_profiles.state = 'published' and free_listing is false")
  end

  def self.count_newest_full_members
    User.count(:include => "user_profile", :conditions => "user_profiles.state = 'published' and free_listing is false")
  end

  def select_tab(tab_slug)
    if tab_slug.nil?
      tabs.first
    else
      case tab_slug
      when Tab::ARTICLES:
        virtual_tab = VirtualTab.new(Tab::ARTICLES, "Articles", "articles/index", "articles/nav" )
        return virtual_tab
      when Tab::SPECIAL_OFFERS:
        virtual_tab = VirtualTab.new(Tab::SPECIAL_OFFERS, "Special Offers", "special_offers/index", "special_offers/nav" )
        return virtual_tab
      else
        tabs.find_by_slug(tab_slug) || tabs.first
      end
    end
  end

  def reviewer?
    has_role?("reviewer")
  end

  def admin?
    has_role?("admin")
  end

  def resident_expert_admin?
    has_role?("resident_expert_admin")
  end

  def full_member?
    has_role?("full_member")
  end

  def resident_expert?
    has_role?("resident_expert")
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

  def remove_role(role_string)
    role = Role.find_by_name(role_string)
    unless role.nil? || !has_role?(role_string)
      self.roles.delete(role)
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
		self.slug = computed_slug
	end

	def computed_slug
		full_name.parameterize
	end

  def phone_prefix
    @phone_prefix ||
     (unless phone.blank?
        phone_bits = phone.split(")")
        phone_bits.first.gsub(/\(/, '')
      end)
  end

  def phone_suffix
    @phone_suffix ||
     (unless phone.blank?
        phone_bits = phone.split(")")
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
        mobile_bits = mobile.split(")")
        mobile_bits.first.gsub(/\(/, '')
      end)
  end

  def mobile_suffix
    @mobile_suffix ||
     (unless mobile.blank?
        mobile_bits = mobile.split(")")
        if mobile_bits.size > 1
          mobile_bits.last
        else
          ""
        end
      end)
  end

  # #describes subcategories in a sentence
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
    if resident_expert?
      self.membership_type = "resident_expert"
    end
  end
  def get_membership_type
    if self.membership_type.nil?
      if full_member?
        self.membership_type = "full_member"
      else
        self.membership_type = "free_listing"
      end
    end
    case membership_type
    when "full_member"
      self.free_listing=false
      unless full_member?
        self.member_since = Time.now.utc
        self.member_until = 1.year.from_now
        self.add_role("full_member")
      end
    else
      self.free_listing=true
      unless has_role?("free_listing")
        self.add_role("free_listing")
      end
    end
    # #!IMPORTANT: always return true in an around filter: see http://www.dansketcher.com/2006/12/30/activerecordrecordnotsaved-before_save-problem/
    return true
  end

  def name_with_email
    "#{name} [#{email}]"
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
        if category_id.nil?
          #regional search
          User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r where u.state='active' and u.region_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing", region_id], :page => page, :per_page => $search_results_per_page )
        else
          #category search
          User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r, categories_users cu where u.state='active' and cu.user_id = u.id and cu.category_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing, cu.position", category_id], :page => page, :per_page => $search_results_per_page )
        end
			else
        if category_id.nil?
          User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r where u.state='active' and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing", district_id], :page => page, :per_page => $search_results_per_page )
        else
          User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r, categories_users cu where u.state='active' and cu.user_id = u.id and cu.category_id = ? and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing, cu.position", category_id, district_id], :page => page, :per_page => $search_results_per_page )
        end
			end
		else
			if district_id.nil?
        if region_id.nil?
          User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where u.state='active' and su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing, su.position", subcategory_id],  :page => page, :per_page => $search_results_per_page )
        else
          User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where u.state='active' and su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and u.region_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing, su.position", subcategory_id, region_id],  :page => page, :per_page => $search_results_per_page )
        end
			else
				User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where u.state='active' and su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by free_listing, su.position", subcategory_id, district_id], :page => page, :per_page => $search_results_per_page )
			end
		end
	end

	def assemble_phone_numbers
    self.mobile = "(#{mobile_prefix})#{mobile_suffix}"
    self.phone = "(#{self.phone_prefix})#{self.phone_suffix}"
	end

  def disassemble_phone_numbers
    unless phone.blank? && !phone.include?(")")
      phone_bits = phone.split(")")
      self.phone_prefix = phone_bits.first.gsub(/\(/, '')
      self.phone_suffix = phone_bits.last
    end
    unless mobile.blank? && !mobile.include?(")")
      mobile_bits = mobile.split(")")
      self.mobile_prefix = mobile_bits.first.gsub(/\(/, '')
      self.mobile_suffix = mobile_bits.last
    end
  end

	def validate
		if professional?
      if subcategory1_id.blank?
        errors.add(:subcategory1_id, "^You must select your main expertise")
      end
      # #combining name and business name must produce a unique string so that
      # we can slug it
			if business_name.blank?
        duplicate_users_count = User.count_by_sql(["select count(u.*) as count from users u where lower(first_name) = lower(?) and lower(last_name) = lower(?) and lower(email) <> lower(?)", first_name, last_name, email])
        if duplicate_users_count > 0
          errors.add(:first_name, "^There is already a user with the same name. Please enter a business name to differentiate yourself or change your name (by adding a middle name, for instance)")
        end
      else
        duplicate_users_count = User.count_by_sql(["select count(u.*) as count from users u where lower(business_name) = lower(?) and lower(first_name) = lower(?) and lower(last_name) = lower(?) and lower(email) <> lower(?)", business_name, first_name, last_name, email])
        if duplicate_users_count > 0
          errors.add(:business_name, "^There is already a user with the same name and business name")
        end
			end
		end
	end

  # Authenticates a user by their login name and unencrypted password.  Returns
  # the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine. We really
  # need a Dispatch Chain here or something. This will also let us return a
  # human error message.
  #
  def self.authenticate(email, password)
    u = find :first, :conditions => { :email => email } # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # Check if a user has a role.
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end
  
  protected

  def make_activation_code
#    self.deleted_at = nil
#    self.activation_code = self.class.make_token
  end

  def locate_address
      address = [address1, suburb, district.name, "New Zealand"].reject{|o| o.blank?}.join(", ")
      begin
        location = ImportUtils.geocode(address)
        logger.debug("====== Geocoding: #{address}: #{location.inspect}")
        self.latitude = location.latitude
        self.longitude = location.longitude
      rescue Graticule::AddressError
        logger.warn("Couldn't geocode address: #{address}")
      end
  end
end
