require File.dirname(__FILE__) + '/../../lib/helpers'
require 'digest/sha1'

class User < ActiveRecord::Base
  extend ActiveSupport::Memoizable
  include AASM
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include ContactSystem
  include SubcategoriesSystem
  include MultiAfterFindSystem
  include Sluggable
  
  aasm_column :state
  
  aasm_initial_state :unconfirmed

  aasm_state :unconfirmed
  aasm_state :active
  aasm_state :inactive
  
  aasm_event :confirm do
    transitions :from => :unconfirmed, :to => :active
  end
  
  aasm_event :deactivate do
    transitions :from => :active, :to => :inactive, :on_transition => :"unpublish!"
  end
  
  aasm_event :reactivate do
    transitions :from => :inactive, :to => :active, :on_transition => :"publish!"
  end
  
  has_attached_file :photo, :styles => { :medium => "150x220>", :thumbnail => "100x150>" },
   :convert_options => { :all => "-quality 100"},
   :url  => "/assets/profiles/:id/:style/:basename.:extension",
   :path => ":rails_root/public/assets/profiles/:id/:style/:basename.:extension"
   
  #validation
  validates_length_of :name, :maximum => 100
  validates_length_of :phone, :maximum => 14, :allow_blank => true
  validates_length_of :mobile, :maximum => 14, :allow_blank => true
  validates_presence_of :email, :first_name, :last_name
  validates_presence_of :district, :message => "^Your area can't be blank", :if => Proc.new { |user| !user.admin? }
  validates_length_of :email, :within => 6..100 #r@a.wk
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD
  validates_attachment_size :photo, :less_than => 3.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/pjpeg', 'image/png', 'image/gif']
  validates_format_of :subdomain, :with => /^[A-Za-z0-9-]+$/, :message => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false, :allow_blank => true
  validates_exclusion_of :subdomain, :in => %w( www staging redmine logged mail bookings logged-staging assets assets0 assets1 assets2 assets3 staging-assets0 staging-assets1 staging-assets2 staging-assets3 ), :message => "The subdomain <strong>{{value}}</strong> is reserved and unavailable."
  
  # Relationships
  has_many :stored_tokens, :order => "card_expires_on desc", :dependent => :delete_all 
  has_many :friend_messages, :dependent => :delete_all, :foreign_key => "from_user_id" 
  has_many :messages, :dependent => :delete_all 
  has_many :roles_users, :dependent => :delete_all
  has_many :roles, :through => :roles_users, :uniq => true 
  belongs_to :region
  belongs_to :district
  has_many :authored_newsletters, :foreign_key => :author_id, :class_name => "Newsletter"
  has_many :published_newsletters, :foreign_key => :publisher_id, :class_name => "Newsletter" 
  has_many :articles, :foreign_key => :author_id
  has_many :how_tos, :foreign_key => :author_id
	has_many :subcategories_users, :order => "expertise_position", :dependent => :delete_all
	has_many :subcategories, :through => :subcategories_users, :include => :subcategories_users, :order => "subcategories_users.expertise_position"
	has_many :expert_subcategories, :through => :subcategories_users, :include => :subcategories_users, :source => :subcategory, :conditions => "subcategories_users.expertise_position is not null"
	has_many :categories_users, :dependent => :delete_all
	has_many :categories, :through => :categories_users
  has_many :tabs, :order => "position", :dependent => :delete_all
  has_one :user_profile, :dependent => :delete
  has_many :payments, :dependent => :delete_all
  has_many :user_emails, :dependent => :delete_all
  has_many :user_events, :dependent => :delete_all
  has_many :visited_user_events, :class_name => "UserEvent", :foreign_key => :visited_user_id, :dependent => :delete_all 
  has_many :special_offers, :foreign_key => :author_id
  has_many :gift_vouchers, :foreign_key => :author_id
  has_many :recommendations, :dependent => :delete_all
  has_many :recommended_by_recommendations, :class_name => "Recommendation", :foreign_key => :recommended_user_id , :dependent => :delete_all
  has_many :recommended_by, :class_name => "User" , :through => :recommended_by_recommendations, :source => :user
  has_many :newsletters_users
  has_many :newsletters, :through => :newsletters_users 
  has_many :orders
  has_many :paid_features
  belongs_to :country
  
  # #named scopes
  named_scope :wants_newsletter, :conditions => "receive_newsletter is true"
  named_scope :wants_professional_newsletter, :conditions => "receive_professional_newsletter is true"
  named_scope :active, :conditions => "users.state='active'"
  named_scope :free_users, :conditions => "free_listing is true"
  named_scope :paying, :conditions => "free_listing is false"
  named_scope :full_members, :include => "roles", :conditions => "roles.name='full_member'"
  named_scope :reviewers, :include => "roles", :conditions => "roles.name='reviewer'"
  named_scope :admins, :include => "roles", :conditions => "roles.name='admin'"
  named_scope :new_users, :conditions => "new_user is true"
  named_scope :notify_unpublished, :conditions => "notify_unpublished IS true"
  named_scope :published, :include => "user_profile",  :conditions => "user_profiles.state='published'" 
  named_scope :unpublished, :include => "user_profile",  :conditions => "user_profiles.state='draft'" 
  named_scope :recently_created, lambda{{:conditions => ["users.created_at > ?", 2.days.ago] }} 
  
  named_scope :with_no_or_old_warning, :conditions => ["feature_warning_sent IS NULL or feature_warning_sent < ?", 1.year.ago]
  
  named_scope :with_expired_photo, :conditions => "paid_photo IS TRUE AND paid_photo_until IS NOT NULL AND paid_photo_until < now()"
  named_scope :with_expiring_photo, lambda { |warning_period| { :conditions => "paid_photo IS TRUE AND paid_photo_until IS NOT NULL AND paid_photo_until > now() AND paid_photo_until < '#{warning_period.to_s(:db)}'"}}
  named_scope :with_expired_highlighted, :conditions => "paid_highlighted IS TRUE AND paid_highlighted_until IS NOT NULL AND paid_highlighted_until < now()"
  named_scope :with_expiring_highlighted, lambda { |warning_period| { :conditions => "paid_highlighted IS TRUE AND paid_highlighted_until IS NOT NULL AND paid_highlighted_until > now() AND paid_highlighted_until < '#{warning_period.to_s(:db)}'"}}
  named_scope :with_expired_special_offers, :conditions => "paid_special_offers > 0 AND paid_special_offers_next_date_check IS NOT NULL AND paid_special_offers_next_date_check < now()"
  named_scope :with_expiring_special_offers, lambda { |warning_period| { :conditions => "paid_special_offers > 0 AND paid_special_offers_next_date_check IS NOT NULL AND paid_special_offers_next_date_check > now() AND paid_special_offers_next_date_check < '#{warning_period.to_s(:db)}'"}}
  named_scope :with_expired_gift_vouchers, :conditions => "paid_gift_vouchers > 0 AND paid_gift_vouchers_next_date_check IS NOT NULL AND paid_gift_vouchers_next_date_check < now()"
  named_scope :with_expiring_gift_vouchers, lambda { |warning_period| { :conditions => "paid_gift_vouchers > 0 AND paid_gift_vouchers_next_date_check IS NOT NULL AND paid_gift_vouchers_next_date_check > now() AND paid_gift_vouchers_next_date_check < '#{warning_period.to_s(:db)}'"}}
  named_scope :has_paid_special_offers, :conditions => "paid_special_offers > 0 AND paid_special_offers_next_date_check IS NOT NULL AND paid_special_offers_next_date_check > now()"
  named_scope :has_paid_gift_vouchers, :conditions => "paid_gift_vouchers > 0 AND paid_gift_vouchers_next_date_check IS NOT NULL AND paid_gift_vouchers_next_date_check > now()"
  named_scope :hasnt_received_offers_reminder_recently, :conditions => ["offers_reminder_sent_at IS NULL OR offers_reminder_sent_at < ?", 1.month.ago]
  named_scope :homepage_featured, :conditions => ["homepage_featured is true"] 
  
  # #around filters
	before_validation :trim_stuff
  before_create :get_region_from_district, :get_membership_type, :set_country
  before_update :get_region_from_district, :get_membership_type
  after_create :create_profile, :add_tabs, :generate_activation_code, :send_confirmation_email
  before_validation :downcase_subdomain  

  attr_protected :admin, :main_role, :member_since, :member_until, :resident_since, :resident_until, :status, :homepage_featured, :homepage_featured_resident
	attr_accessor :membership_type, :accept_terms, :admin, :main_role, :old_password

  WEBSITE_PREFIX = "http://"
  DEFAULT_REFERRAL_COMMENT = "Just letting you know about this site __SITE__NAME__ that I've just added my profile to - I strongly recommend checking it out.\n\nHealth, Well-being and Development professionals in NZ can get a FREE profile - it's like a complete online marketing campaign... but without the headache!"
  DAILY_USER_ROTATION = 3
  MAX_RECENT_ARTICLES = 3
  FEATURE_PHOTO = "photo"
  FEATURE_HIGHLIGHT = "highlighted profile"
  FEATURE_SO = "trial session"
  FEATURE_GV = "gift voucher"
  NUMBER_HOMEPAGE_FEATURED_RESIDENT_EXPERTS = 3
  NUMBER_HOMEPAGE_FEATURED_USERS = 3
  DELETE_UNCONFIRMED_USERS_AFTER_IN_DAYS = 30
  WARNING_USERS_WILL_BE_DELETED_IN_DAYS = 7
  WARNING_USERS_WABOUT_TO_BE_DELETED_IN_DAYS = 2
  
  def tabs_without_subcat
    user_tab_titles = self.tabs.map(&:title)
    user_subcategory_names = self.subcategories.map(&:name)
    tabs_without_subcat = []
    user_tab_titles.each do |title|
      if !user_subcategory_names.include?(title)
        tabs_without_subcat << title
      end
    end
    return tabs_without_subcat
  end
  
  def count_unpaid_published_special_offers
    unpaid = self.special_offers.published.count - self.paid_special_offers
    unpaid = 0 if unpaid < 0
    return unpaid
  end
  
  def count_unpaid_published_gift_vouchers
    unpaid = self.gift_vouchers.published.count - self.paid_gift_vouchers
    unpaid = 0 if unpaid < 0
    return unpaid
  end
  
  def self.will_be_deleted_in_1_week
    User.find(:all, :conditions => ["state='unconfirmed' and created_at < ?", (DELETE_UNCONFIRMED_USERS_AFTER_IN_DAYS-WARNING_USERS_WILL_BE_DELETED_IN_DAYS).days.ago])
  end
  
  def send_confirmation_email
    UserMailer.deliver_new_user_confirmation_email(self)
  end
  
  def generate_activation_code
    self.update_attribute(:activation_code, Digest::SHA1.hexdigest("#{email}#{Time.now}#{id}"))
  end
  
  def self.resident_experts(country)
    User.find(:all, :conditions => ["is_resident_expert is true and country_id = ?", country.id])
  end
  
  def set_country
    if self.country_id.nil?
      self.country_id = self.district.country_id
    end
  end
  
  def self.homepage_featured_resident_experts(country)
    User.find(:all, :conditions => ["homepage_featured_resident is true and country_id = ?", country.id], :limit => NUMBER_HOMEPAGE_FEATURED_RESIDENT_EXPERTS)
  end

  def self.homepage_featured_users
    User.find(:all, :conditions => ["homepage_featured is true"], :limit => DAILY_USER_ROTATION)
  end

  def self.extract_features_from_name(feature_names)
    so = 0
    gv = 0
    feature_names.each do |name|
      if name =~ Regexp.new(FEATURE_SO)
        so = name.split(" ").first.to_i
      end
      if name =~ Regexp.new(FEATURE_GV)
        gv = name.split(" ").first.to_i
      end
    end
    photo = feature_names.include?(FEATURE_PHOTO)
    highlighted = feature_names.include?(FEATURE_HIGHLIGHT)
    return photo, highlighted, so, gv
  end

  def init_order_from_feature_names(feature_names)
    photo, highlighted, so, gv = User.extract_features_from_name(feature_names)
    if !photo && !highlighted && so == 0 && gv == 0
      logger.error("Error while trying to charge auto-renewal features for user #{self.full_name}: there were no features to renew...")
    else
      order = Order.new(:photo => photo, :highlighted => highlighted,
      :special_offers => so, :gift_vouchers => gv, :user => self,
      :whole_package => photo && highlighted && so >= 1 && gv >= 1 && self.had_whole_package_order_1_year_ago?(self.paid_photo_until))
      return order
    end
  end
  
  def charge_auto_renewal(feature_names)
    unless self.stored_tokens.blank?
      order = self.init_order_from_feature_names(feature_names)
      if order.save
        p = order.payment
        p.stored_token_id = self.stored_tokens.first.id
        logger.info("Charged features: #{feature_names.to_sentence} to user: #{self.name_with_email}")
        p.purchase!
      else
        logger.error("There was an error while charge auto-renewal features; the order is not valid")
      end
    end
  end
  
  def had_whole_package_order_1_year_ago?(date)
    !self.orders.blank? && !self.orders.find(:all, :conditions => ["state = 'paid' AND whole_package IS TRUE AND created_at BETWEEN ? AND ?", date.advance(:years => -1).advance(:days  => -2), date.advance(:years => -1).advance(:days  => 2)]).blank?
  end
  
  def has_stored_token_older_than?(date)
    !self.stored_tokens.blank? && !date.nil? && date > self.stored_tokens.first.created_at.to_date
  end
  
  def keep_auto_renewable_features(feature_names)
    auto_renewable_features(feature_names, true)    
  end
  
  def remove_auto_renewable_features(feature_names)
    auto_renewable_features(feature_names, false)
  end
  
  def auto_renewable_features(feature_names, keep)
    new_feature_names = []
    feature_names.each do |name|
      field_name = case name
        when FEATURE_PHOTO then "paid_photo_until"
        when FEATURE_HIGHLIGHT then "paid_highlighted_until"
        else
          if name =~ Regexp.new(FEATURE_SO)
            "paid_special_offers_next_date_check"
          else
            if name =~ Regexp.new(FEATURE_GV)
              "paid_gift_vouchers_next_date_check"
            end
          end
      end
      if keep
        new_feature_names << name if self.has_stored_token_older_than?(self.send(field_name.to_sym))
      else
        new_feature_names << name if !self.has_stored_token_older_than?(self.send(field_name.to_sym))
      end
    end
    return new_feature_names
  end
  
  def has_current_stored_tokens?
    self.stored_tokens.not_expired.size > 0
  end
  
  def recent_articles
    self.articles.published.find(:all, :limit => MAX_RECENT_ARTICLES, :order => "published_at desc")
  end
    
  def warning_deactivate?
    self.paid_special_offers > 0 || self.paid_gift_vouchers > 0 
  end
  
  def unpublish!
    if !self.user_profile.nil? && self.user_profile.published?
      self.user_profile.remove!
    end
    self.special_offers.published.each {|so| so.remove!}
    self.gift_vouchers.published.each {|gv| gv.remove!}
  end
  
  def publish!
    if !self.user_profile.nil? && self.user_profile.draft?
      self.user_profile.publish!
    end
    self.subcategories.each do |s|
      self.compute_points(s)
    end
  end
  
  def active?
    state == "active"
  end
  
  def articles_to_become_RE_in_subcat(subcat)
    (points_to_become_RE_in_subcat(subcat)/Article::POINTS_FOR_RECENT_ARTICLE.to_f).ceil
  end
  
  def points_to_become_RE_in_subcat(subcat)
    experts = subcat.resident_experts(self.country)
    if experts.blank? || experts.size < Subcategory::MAX_RESIDENT_EXPERTS_PER_SUBCATEGORY
      Article::POINTS_FOR_RECENT_ARTICLE
    else
      (experts[Subcategory::MAX_RESIDENT_EXPERTS_PER_SUBCATEGORY-1].try(:points_in_subcategory, subcat.id) || 0) - self.points_in_subcategory(subcat.id)+1
    end
  end
  
  def ranking_in_subcat(subcat)
    if subcat.users_with_points.include?(self)
      subcat.users_with_points.index(self)+1
    else
      nil
    end
  end
  
  def resident_expert_in_subcat?(subcat)
    !subcat.resident_experts(self.country).blank? && subcat.resident_experts(self.country).include?(self)
  end
  
  def points_in_subcategory(subcat_id)
    su = self.subcategories_users.find_by_subcategory_id(subcat_id)
    if su.nil?
      0
    else
      su.points || 0
    end
  end
  
  def has_article_with_same_slug?(id, slug)
    begin
  		if id.nil? 
  		  res = self.articles.find_by_slug(slug)
  		else
  		  res = self.articles.find(:conditions => ["slug = ? and id <> ?", slug, id])
  		end
  		return !res.blank?
		rescue ActiveRecord::RecordNotFound
		  return false
	  end
  end
  
  def hasnt_changed_special_offers_recently?
    special_offers.reject{|so| so.published_at.nil?}.map(&:published_at).blank? || special_offers.reject{|so| so.published_at.nil?}.map(&:published_at).sort.last < 1.month.ago
  end
  
  def hasnt_changed_gift_vouchers_recently?
    gift_vouchers.reject{|gv| gv.published_at.nil?}.map(&:published_at).blank? || gift_vouchers.reject{|gv| gv.published_at.nil?}.map(&:published_at).sort.last < 1.month.ago
  end

  def self.rotate_featured_resident_experts(country)
    users_to_feature = User.find(:all, :conditions => ["country_id = ? and last_homepage_featured_resident_at is NULL and is_resident_expert is true and paid_photo is true", country.id], :limit => User::NUMBER_HOMEPAGE_FEATURED_RESIDENT_EXPERTS)
    if users_to_feature.size < User::NUMBER_HOMEPAGE_FEATURED_RESIDENT_EXPERTS
      if users_to_feature.blank?
        more_users_to_feature = User.find(:all, :conditions => ["paid_photo is true and is_resident_expert is true and country_id = ?", country.id], :order => "last_homepage_featured_resident_at")
      else
        more_users_to_feature = User.find(:all, :conditions => ["paid_photo is true and is_resident_expert is true and country_id = ? and id not in (?)", country.id, users_to_feature.map(&:id)], :order => "last_homepage_featured_resident_at")
      end
      users_to_feature = users_to_feature.concat(more_users_to_feature)[0..User::NUMBER_HOMEPAGE_FEATURED_RESIDENT_EXPERTS-1]
    end
    User.homepage_featured_resident_experts(country).each {|a| a.update_attribute(:homepage_featured_resident, false)}
    users_to_feature.each do |user|
      user.homepage_featured_resident = true
      user.last_homepage_featured_resident_at = Time.now
      user.save!
    end    
  end
  
  def self.rotate_featured
    existing_featured_users = User.homepage_featured
    featured_users = User.find(:all, :include => "user_profile",
     :conditions => "user_profiles.state = 'published' and free_listing is false 
                     and users.state='active' and users.paid_photo is true 
                     and last_homepage_featured_at is null",
     :limit => DAILY_USER_ROTATION)
    if featured_users.size < DAILY_USER_ROTATION
      new_featured_users = User.find(:all, :include => "user_profile",
        :conditions => ["user_profiles.state = 'published' 
          and free_listing is false and users.state='active' 
          and users.paid_photo is true 
          and users.id not in (?)",
          existing_featured_users.concat(featured_users).map(&:id)],
        :order => "last_homepage_featured_at",
        :limit => DAILY_USER_ROTATION-featured_users.size)
      featured_users = featured_users.concat(new_featured_users)[0..DAILY_USER_ROTATION-1]
    end
    existing_featured_users.each do |user|
      user.update_attribute(:homepage_featured, false)
    end
    featured_users.each do |user|
      user.homepage_featured = true
      user.last_homepage_featured_at = Time.now
      user.save!
    end
  end
  
  def compute_points(subcategory)
    if active?
      articles_count_in_last_month = self.articles.published.count(:all, :include => "articles_subcategories", :conditions => ["published_at >= ? and articles_subcategories.subcategory_id = ?", 30.days.ago, subcategory.id])
      older_articles_count = self.articles.published.count(:all, :include => "articles_subcategories", :conditions => ["published_at < ? and articles_subcategories.subcategory_id = ?", 30.days.ago, subcategory.id])
      (articles_count_in_last_month * Article::POINTS_FOR_RECENT_ARTICLE) + (older_articles_count * Article::POINTS_FOR_OLDER_ARTICLE)
    else
      0
    end
  end
  
  def downcase_subdomain
    self.subdomain.downcase! if attribute_present?("subdomain")
  end  
  
  def published?
    !self.user_profile.nil? && self.user_profile.published?
  end
  
  def count_visits_since(start_date)
    UserEvent.count(:all, :conditions => ["subcategory_id in (select subcategory_id from subcategories_users where user_id = ? ) AND event_type = '#{UserEvent::VISIT_SUBCATEGORY}' AND logged_at > ?", self.id, start_date])
  end
  
  def had_visits_since?(start_date)
    self.count_visits_since(start_date) > 0
  end
  
  def visits_since(start_date)
    res = {}
    self.subcategories.each do |sub|
      count = UserEvent.count(:all, :conditions => ["subcategory_id = ? AND event_type = '#{UserEvent::VISIT_SUBCATEGORY}' AND logged_at > ?", sub.id, start_date])
      unless count == 0
        res[sub.name] = count
      end
    end
    res
  end
  
  def short_description_from_tabs(selected_tab)
    if selected_tab.nil?
      if self.tabs.first.nil?
        ""
      else
        self.tabs.first.content[0..300].gsub(/<\/?[^>]*>/,  "")
      end
    else
      if selected_tab.content.nil?
        ""
      else
        selected_tab.content[0..300].gsub(/<\/?[^>]*>/,  "")
      end
    end
  end
  
  def warn_expired_features(expired_feature_names)
    UserMailer.deliver_expired_features(self, expired_feature_names) unless expired_feature_names.blank?
  end
  
  def warn_expiring_features_in_one_week(expiring_feature_names)
    if self.has_current_stored_tokens?
      order = order = self.init_order_from_feature_names(expiring_feature_names)
      UserMailer.deliver_charging_card(self, expiring_feature_names, order.compute_amount) unless expiring_feature_names.blank?
    else
      UserMailer.deliver_expiring_features(self, expiring_feature_names) unless expiring_feature_names.blank?
    end
    self.update_attribute(:feature_warning_sent, Time.now)
  end
  
  def self.get_emails_from_string(email_string)
    emails = email_string.split(/[ |,]/)
    emails.reject{|e| !e.match(RE_EMAIL_OK)}
  end

  def count_not_expiring_special_offers
    count = 0
    orders.not_expiring.each {|o| count += o.special_offers}
    return count    
  end
  
  def count_not_expired_special_offers
    count = 0
    orders.not_expired.each {|o| count += o.special_offers}
    return count
  end
  
  def count_not_expiring_gift_vouchers
    count = 0
    orders.not_expiring.each {|o| count += o.gift_vouchers}
    return count    
  end
  
  def count_not_expired_gift_vouchers
    count = 0
    orders.not_expired.each {|o| count += o.gift_vouchers}
    return count
  end

  def has_paid_special_offers?
    !paid_special_offers.nil? && paid_special_offers > 0
  end

  def has_paid_gift_vouchers?
    !paid_gift_vouchers.nil? && paid_gift_vouchers > 0
  end

  def has_paid_features?
    paid_photo? || paid_highlighted? || has_paid_special_offers? || has_paid_gift_vouchers?
  end

  def remove_subcats(all_subcategories)
    self.subcategories.each do |s|
      all_subcategories.delete(s.name)
    end
    return all_subcategories
  end

  def unedited_tabs_error_msg
    if self.unedited_tabs.size == 1
      "Your tab #{unedited_tabs.first.title} is incomplete: please enter information or delete the tab"
    else
      "Your tabs #{unedited_tabs.map(&:title).to_sentence} are incomplete: please enter information or delete these tabs"
    end
  end

  def all_tabs_valid?
    self.unedited_tabs.blank? && self.tabs.select{|t| t.content.blank?}.blank?
  end

  def unedited_tabs
     unedited_tabs = []
     tabs.each do |tab|
       unedited_tabs << tab if tab.needs_edit?
     end
     unedited_tabs
  end
  

  def has_max_number_tabs?
    !tabs.blank? && tabs.size >= Tab::MAX_PER_USER
  end
  
  def self.currently_selected_and_last_10_published(newsletter)
    newsletter.users | self.find(:all, :include => "user_profile", :conditions => "user_profiles.published_at is not null",  :order => "published_at desc", :limit => 10)
  end
  

  def renew_token
    new_token = Digest::SHA1.hexdigest("#{salt}#{Time.now}#{id}")
    self.update_attribute(:unsubscribe_token, new_token)
    return new_token
  end
  
  def expertise_subcategory_id
    expertise_subcategory.try(:id)
  end
  
  def check_and_update_attributes(user_hash)
    self.main_role = user_hash[:main_role]
    self.admin = user_hash[:admin] == "1"
    if user_hash[:main_role] == "Full member"
      self.member_since = Time.zone.parse("#{user_hash['member_since(1i)']}-#{user_hash['member_since(2i)']}-#{user_hash['member_since(3i)']}")
      self.member_until = Time.zone.parse("#{user_hash['member_until(1i)']}-#{user_hash['member_until(2i)']}-#{user_hash['member_until(3i)']}")
    end
    if user_hash[:main_role] == "Resident expert"
      #TO DO: make_resident_expert, test if it is already an expert...
      self.resident_since = Time.zone.parse("#{user_hash['resident_since(1i)']}-#{user_hash['resident_since(2i)']}-#{user_hash['resident_since(3i)']}")
      self.resident_until = Time.zone.parse("#{user_hash['resident_until(1i)']}-#{user_hash['resident_until(2i)']}-#{user_hash['resident_until(3i)']}")
      subcategory = Subcategory.find(user_hash[:expertise_subcategory_id])
      if subcategory.nil?
        self.errors.add(:expertise_subcategory_id, "doesn't exist")
        return false
      else
        if !subcategory.resident_expert.nil? && subcategory.resident_expert != self
          self.errors.add(:expertise_subcategory_id, "has already a resident expert: #{subcategory.resident_expert.full_name}")
          return false
        else
          self.expertise_subcategory = subcategory
        end
      end
    end
    self.save
  end

  def admin
    admin?
  end
  
  def admin=(bool)
    if bool && !self.admin?
      self.add_role("admin")
    end
    if !bool && self.admin
      self.remove_role("admin")
    end
  end
  
  def main_role
    if resident_expert?
      "Resident expert"
    else
      if full_member?
        "Full member"
      else
        "Free listing"
      end
    end
  end

  def main_role=(new_role)
    if new_role == "Free listing" && !self.free_listing?
      self.free_listing = true
      self.remove_role("full_member")
      self.remove_role("resident_expert")
    end
    if new_role == "Full member" && !self.full_member?
      self.free_listing = false
      self.add_role("full_member")
      self.remove_role("resident_expert")
    end
    if new_role == "Resident expert" && !self.resident_expert?
      self.free_listing = false
      self.remove_role("full_member")
      self.add_role("resident_expert")
    end
  end

  def roles_description
    if admin?
      res = "Admin, "
    else
      res = ""
    end
    if resident_expert?
      res << "Resident expert for #{expertise_subcategory.name}"
    else
      if full_member?
        res << "Full member"
      end
    end
  end

  def can_add_link?
    admin?
  end

  def label(url="")
    if url.blank?
      "#{self.full_name}<br/>#{self.expertise}"
    else
      "<a href=\"#{url}\">#{self.full_name}</a><br/>#{self.expertise}"
    end
    
  end

  def self.published_in_last_2_months(start=Time.now)
    self.find(:all, :include => "user_profile", :conditions => ["user_profiles.published_at BETWEEN ? AND ?", start.advance(:months => -2), Time.now])    
  end

  def location
    location_array = self.city.blank? ? [self.district.try(:name)] : [self.city]
    location_array << self.region.try(:name)
    return location_array.join(", ")
  end

  def find_current_payment
    self.payments.pending.find(:first, :order => "created_at desc" ) || self.payments.create!(Payment::TYPES["renew_#{self.highest_role}".to_sym])
  end

  def highest_role
    if resident_expert?
      "resident_expert"
    else
      if full_member?
        "full_member"
      else
        "free_listing"
      end
    end
  end

  def key_expertise_name(current_subcategory=nil)
    if current_subcategory.nil?
      self.main_expertise_name
    else
      current_subcategory.try(:name)
    end
  end
  
  def other_expertise_names(current_subcategory=self.main_expertise)
    res = subcategories.dup
    res.reject{|s| s==current_subcategory}.map(&:name)
  end
  
  def trim_stuff
    self.first_name = self.first_name.try(:strip)
    self.last_name = self.last_name.try(:strip)
    self.email = self.email.try(:strip)
    self.email = self.email.try(:downcase)
    self.business_name = self.business_name.try(:strip)
  end
  
  def self.find_paying_member_by_name(my_name)
    if my_name.match(/-/)
      User.find_by_sql(["select * from users where free_listing is false AND lower(first_name) || ' ' || lower(last_name) || ' - ' || lower(business_name) = lower(?)", my_name]).first
    else
      User.find_by_sql(["select * from users where free_listing is false AND lower(first_name) || ' ' || lower(last_name) = lower(?)", my_name]).first
    end
  end
  
  def user_profile_url
    help.expanded_user_url(self)
  end
  
  def member_since_launch_date?
    if resident_expert?
      !resident_since.nil? && resident_since > $launch_date
    else
      if full_member?
        !member_since.nil? && member_since > $launch_date
      end
    end
  end
  
  def clean_website
    if website.starts_with?(WEBSITE_PREFIX)
      website
    else
      "#{WEBSITE_PREFIX}#{website}"
    end
  end

  def make_resident_expert!(subcategory)
    if !subcategory.resident_expert.nil?
      logger.error("Trying to make user: #{self.full_name} resident expert on #{subcategory.name}, but there is already an expert for this subcategory: #{subcategory.resident_expert.full_name}")
    else
      #remove free listing role as it will make a user appear twice
      self.free_listing = false
      self.remove_role("free_listing")
      
      self.add_role("resident_expert")
      unless self.has_role?("full_member")
        self.add_role("full_member")
        unless self.user_profile.nil?
          #reset publication information
          self.user_profile.published_at = nil
          self.user_profile.approved_at = nil
          self.user_profile.approved_by_id = nil
          self.user_profile.save!
        end
      end
      self.expertise_subcategory = subcategory
      self.resident_since = Time.now
      self.resident_until = 1.year.from_now
      self.save!
      subcategory.resident_expert = self
      subcategory.save!
    end
  end

  def method_missing(method_id, *arguments)
    if method_id.to_s =~ /find_([_a-zA-Z]*)/
      plural_objs_sym = $1.pluralize.to_sym
      if self.respond_to?(plural_objs_sym)
        id = arguments[0]
        if self.admin?
          Object.const_get($1.classify).find(id)
        else
          self.send(plural_objs_sym).find(id)
        end
      else    
        if method_id.to_s =~ /find_([_a-zA-Z]*)_for_user/
          plural_objs_sym = $1.pluralize.to_sym
          if self.respond_to?(plural_objs_sym)
            slug = arguments[0]
            current_user = arguments[1]
            if current_user == self
              self.send(plural_objs_sym).find_by_slug(slug)
            else
              if !current_user.nil? && current_user.admin?
                Object.const_get($1.classify).find_by_author_id_and_slug(self.id, slug)
              else
                self.send(plural_objs_sym).find_by_state_and_slug("published", slug)
              end
            end
          end
        end
      end
    else
      super
    end
  end

  def invoices
    Invoice.find_by_sql(["select invoices.* from payments, invoices where payments.user_id = ? and payments.id = invoices.payment_id", self.id])
  end

  def css_class_role_description
    if self.free_listing?
      "title-user-free-listing"
    else
      "title-user-paying"
    end
  end

  def css_role_description
    role_description.gsub(/ /, "_")
  end

  def role_description
    if resident_expert?
      "resident expert"
    else
      if full_member?
        ""
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

  def full_info
    if photo.exists? && user_profile.published?
      res = "<div class='bam-gmarker-photo'><img src='#{photo.url(:thumbnail)}'/></div><div class='bam-gmarker-text'>"
    else
      res = "<div class='bam-gmarker-text'>"
    end
    res << [full_name, main_expertise_name, address1, suburb, district.name].reject{|o| o.blank?}.join("<br/>")
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
      return special_offers_count + gift_vouchers_count
    else
      return published_special_offers_count + published_gift_vouchers_count
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
      unless sub1.nil?
        self.subcategories << sub1
        unless self.categories.include?(sub1.category)
          self.categories << sub1.category
        end
        # update points
        su = SubcategoriesUser.find_by_subcategory_id_and_user_id(sub1.id, self.id)
        unless su.nil?
          su.update_attribute(:points, self.compute_points(sub1))
        end
        
        # #update expertise position
        unless @old_positions.blank? || @old_positions[self.subcategory1_id].blank?
          su = SubcategoriesUser.find_by_subcategory_id_and_user_id(sub1.id, self.id)
          unless su.nil?
            su.update_attribute(:position, @old_positions[self.subcategory1_id])
          end
        end
      end
    end
    unless subcategory2_id.blank?
      sub2 = Subcategory.find(self.subcategory2_id)
      unless sub2.nil? || self.subcategories.include?(sub2)
        self.subcategories << sub2
        unless self.categories.include?(sub2.category)
          self.categories << sub2.category
        end
        # update points
        su = SubcategoriesUser.find_by_subcategory_id_and_user_id(sub2.id, self.id)
        unless su.nil?
          su.update_attribute(:points, self.compute_points(sub2))
        end
        
        # #update expertise position
        unless @old_positions.blank? || @old_positions[self.subcategory2_id].blank?
          su = SubcategoriesUser.find_by_subcategory_id_and_user_id(sub2.id, self.id)
          unless su.nil?
            su.update_attribute(:position, @old_positions[self.subcategory2_id])
          end
        end
      end
    end
    unless subcategory3_id.blank?
      sub3 = Subcategory.find(self.subcategory3_id)
      unless sub3.nil? || self.subcategories.include?(sub3)
        self.subcategories << sub3
        unless self.categories.include?(sub3.category)      
          self.categories << sub3.category
        end
        # update points
        su = SubcategoriesUser.find_by_subcategory_id_and_user_id(sub3.id, self.id)
        unless su.nil?
          su.update_attribute(:points, self.compute_points(sub3))
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
      subcategories.try(:first)
  end

  def main_expertise_name
    if subcategories.blank?
      ""
    else
      subcategories.first.name
    end
  end
  memoize :main_expertise_name

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
    self == stuff.author
  end

  def self.paginated_full_members(page, limit=$full_members_per_page)
    User.paginate(:all, :include => "user_profile", :conditions => "user_profiles.state = 'published' and paid_photo is true and free_listing is false and users.state='active'", :order => "published_at desc", :limit => limit, :page => page )
  end

  def self.published_resident_experts
    User.find(:all, :include => ["user_profile", "roles", "subcategories"], :conditions => "roles.name='resident_expert' and user_profiles.state = 'published' and free_listing is false and users.state='active'", :order => "first_name, last_name")
  end

  def self.count_published_resident_experts(country)
    User.count(:include => ["user_profile", "roles"], :conditions => ["roles.name='resident_expert' and user_profiles.state = 'published' and free_listing is false and users.state='active' and users.country_id = ?", country.id])
  end

  def self.published_full_members
    User.find(:all, :include => ["user_profile", "roles"], :conditions => "roles.name='full_member' and user_profiles.state = 'published' and free_listing is false and users.state='active'", :order => "paid_photo desc, published_articles_count desc")
  end

  def self.count_published_full_members(country)
    User.count(:include => ["user_profile", "roles"], :conditions => ["roles.name='full_member' and user_profiles.state = 'published' and free_listing is false and users.state='active' and users.country_id = ?", country.id])
  end
  
  def self.count_newest_full_members
    User.count(:include => "user_profile", :conditions => "user_profiles.state = 'published' and free_listing is false and users.state='active'")
  end

  def select_tab(tab_slug)
    if tab_slug.nil?
      if tabs.blank?
        virtual_tab = VirtualTab.new(Tab::ARTICLES, "Articles", "articles/index", "articles/nav" )
        return virtual_tab
      else
        tabs.first
      end
    else
      case tab_slug
      when Tab::ARTICLES:
        virtual_tab = VirtualTab.new(Tab::ARTICLES, "Articles", "articles/index", "articles/nav" )
        return virtual_tab
      when Tab::OFFERS:
        virtual_tab = VirtualTab.new(Tab::OFFERS, "Offers", "users/special_offers", "special_offers/nav" )
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
    is_resident_expert?
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
    subcategories.each do |s|
      self.add_tab(s)
    end
  end

  # #describes subcategories in a sentence
  def expertise
    subcategories.map(&:name).to_sentence
  end
  
  def create_additional_tab(subcat_id)
    if !subcat_id.nil?
      begin
        subcat = Subcategory.find(subcat_id)
      rescue ActiveRecord::RecordNotFound
      end
      if !subcat.nil?
        self.add_tab(subcat)
      end
    end
  end
  
  def add_tab(subcat)
    if self.has_max_number_tabs?
      return nil
    else
      self.tabs.create(:title => subcat.name,
        :content1_with => Tab::DEFAULT_CONTENT1_WITH,
        :content2_benefits => Tab::DEFAULT_CONTENT2_BENEFITS,  
        :content3_training => Tab::DEFAULT_CONTENT3_TRAINING, 
        :content4_about => Tab::DEFAULT_CONTENT4_ABOUT )
    end
  end

  def remove_tab(tab_slug)
    tab = self.tabs.find_by_slug(tab_slug)
    if tab.nil?
      logger.error("No tab found for #{tab_slug} on user #{self.email}")
    else
      tab.destroy
    end
    #delete corresponding subcategory
    # sub = self.subcategories.find_by_name(tab_slug.split("-").map(&:capitalize).join(" "))
    sub = self.subcategories.find(:first, :conditions => [ "lower(name) = ?", tab_slug.split("-").map(&:downcase).join(" ") ])
    if sub.nil?
      logger.error("Tab #{tab_slug} was removed for user #{self.email}, but there is no corresponding category")
    else
      su = self.subcategories_users.find_by_subcategory_id(sub.id)
      unless su.nil?
        su.destroy
      end
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
    if self.membership_type.blank?
      if free_listing?
        self.membership_type = "free_listing"
      else
        self.membership_type = "full_member"
      end
      if resident_expert?
        self.membership_type = "resident_expert"
      end
    end
    case membership_type
    when "free_listing"
      self.free_listing=true
      unless has_role?("free_listing")
        self.add_role("free_listing")
      end
    when "resident_expert"
      self.free_listing=false
    else
      self.free_listing=false
      unless full_member?
        self.member_since = Time.now.utc
        self.member_until = 1.year.from_now
        self.add_role("full_member")
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

	def self.count_all_by_country_id_and_subcategories(country_id, *subcategories)
		User.count_by_sql(["select count(u.*) as count from users u, subcategories_users su where u.state='active' and u.country_id =? and u.id = su.user_id and su.subcategory_id in (?)", country_id, subcategories])
	end

	def self.search_results(country_id, category_id, subcategory_id, region_id, district_id, page)
		if subcategory_id.nil?
			if district_id.nil?
        if category_id.nil?
          #regional search
          User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r where u.country_id = ? and u.state='active' and u.region_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by paid_photo desc, paid_highlighted desc", country_id, region_id], :page => page, :per_page => $search_results_per_page )
        else
          #category search
          User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r, categories_users cu where u.country_id = ? and u.state='active' and cu.user_id = u.id and cu.category_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by paid_photo desc, paid_highlighted desc, cu.position", country_id, category_id], :page => page, :per_page => $search_results_per_page )
        end
			else
        if category_id.nil?
          User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r where u.country_id = ? and u.state='active' and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by paid_photo desc, paid_highlighted desc", country_id, district_id], :page => page, :per_page => $search_results_per_page )
        else
          User.paginate_by_sql(["select u.* from users u, roles_users ru, roles r, categories_users cu where u.country_id = ? and u.state='active' and cu.user_id = u.id and cu.category_id = ? and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by paid_photo desc, paid_highlighted desc, cu.position", country_id, category_id, district_id], :page => page, :per_page => $search_results_per_page )
        end
			end
		else
			if district_id.nil?
        if region_id.nil?
          User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where u.country_id = ? and u.state='active' and su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by paid_photo desc, paid_highlighted desc, su.position", country_id, subcategory_id],  :page => page, :per_page => $search_results_per_page )
        else
          User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where u.country_id = ? and u.state='active' and su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and u.region_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by paid_photo desc, paid_highlighted desc, su.position", country_id, subcategory_id, region_id],  :page => page, :per_page => $search_results_per_page )
        end
			else
				User.paginate_by_sql(["select u.* from subcategories_users su, users u, roles_users ru, subcategories s, roles r where u.country_id = ? and u.state='active' and su.subcategory_id = s.id and su.user_id = u.id and s.id = ? and u.district_id = ? and (u.free_listing is true or (r.name='full_member')) and r.id = ru.role_id and ru.user_id=u.id order by paid_photo desc, paid_highlighted desc, su.position", country_id, subcategory_id, district_id], :page => page, :per_page => $search_results_per_page )
			end
		end
	end

  def validate_on_create
    if accept_terms.nil? || accept_terms == "0"
      errors.add(:accept_terms, "^Please accept our terms and conditions")      
    end
    # the slug must be unique
    if !User.find_by_slug(computed_slug).nil?
      if business_name.blank?
        errors.add(:first_name, "^There is already a user with the same name (#{first_name} #{last_name}). Please enter a business name to differentiate yourself or change your name (by adding a middle name, for instance)")
      else
        errors.add(:business_name, "^There is already a user with the same name (#{first_name} #{last_name}) and business name (#{business_name})")
      end
    end
  end

  def validate_on_update
    # the slug must be unique
    if User.find_all_by_slug(computed_slug).size > 1
      if business_name.blank?
        errors.add(:first_name, "^There is already a user with the same name (#{first_name} #{last_name}). Please enter a business name to differentiate yourself or change your name (by adding a middle name, for instance)")
      else
        errors.add(:business_name, "^There is already a user with the same name (#{first_name} #{last_name}) and business name (#{business_name})")
      end
    end    
  end

	def validate
	  if !first_name.nil? && first_name.match(/[\.\/#]/)
	    errors.add(:first_name, "cannot contain characters: . # /")
    end
	  if !last_name.nil? && last_name.match(/[\.\/#]/)
	    errors.add(:last_name, "cannot contain characters: . # /")
    end
	  if !business_name.nil? && business_name.match(/[\.\/#]/)
	    errors.add(:last_name, "cannot contain characters: . # /")
    end
    if subcategory1_id.blank? && !self.admin?
      errors.add(:subcategory1_id, "^You must select your main expertise")
    end
	end
  
  # Check if a user has a role.
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s)
  end
  
end
