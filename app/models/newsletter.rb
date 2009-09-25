class Newsletter < ActiveRecord::Base
  include AASM
  belongs_to :author, :class_name => "User"
  belongs_to :publisher, :class_name => "User"
  has_many :newsletters_special_offers
  has_many :newsletters_users
  has_many :articles_newsletters
  has_many :gift_vouchers_newsletters
  has_many :special_offers, :through => :newsletters_special_offers
  has_many :users, :through => :newsletters_users
  has_many :articles, :through => :articles_newsletters
  has_many :gift_vouchers, :through => :gift_vouchers_newsletters
  has_many :mass_emails
  
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :published

  aasm_event :publish do
    transitions :from => :draft, :to => :published, :on_transition => :mark_publish_info 
  end
  aasm_event :retract do
    transitions :to => :draft, :from => :published, :on_transition => :mark_unpublish_info 
  end

  attr_accessor :current_publisher, :special_offers_attributes, :articles_attributes, :gift_vouchers_attributes, :users_attributes
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 255

  after_save :save_attributes

  NUMBER_SPECIAL_OFFERS = 3
  NUMBER_GIFT_VOUCHERS = 3

  def save_attributes
    unless special_offers_attributes.blank?
      self.newsletters_special_offers.destroy_all
      self.special_offers_attributes.each_value do |value|
        sp = SpecialOffer.published.find(value)
        self.special_offers << sp unless sp.nil?
      end
    end
    unless users_attributes.blank?
      self.newsletters_users.destroy_all
      self.users_attributes.each_value do |value|
        sp = User.published.find(value)
        self.users << sp unless sp.nil?
      end
    end
    unless articles_attributes.blank?
      self.articles_newsletters.destroy_all
      self.articles_attributes.each_value do |value|
        sp = Article.published.find(value)
        self.articles << sp unless sp.nil?
      end
    end
    unless gift_vouchers_attributes.blank?
      self.gift_vouchers_newsletters.destroy_all
      self.gift_vouchers_attributes.each_value do |value|
        sp = GiftVoucher.published.find(value)
        self.gift_vouchers << sp unless sp.nil?
      end
    end
  end

  def selected_offer?(offer, index)
    if self.new_record?
      return index < Newsletter::NUMBER_SPECIAL_OFFERS
    else
      self.special_offers.include?(offer)
    end
  end

  def selected_gift_voucher?(gv, index)
    if self.new_record?
      return index < Newsletter::NUMBER_GIFT_VOUCHERS
    else
      self.gift_vouchers.include?(gv)
    end
  end

  def selected_article?(a, index)
    if self.new_record?
      return a.published_at >= 30.days.ago
    else
      self.articles.include?(a)
    end
  end

  def selected_user?(u, index)
    if self.new_record?
      return u.user_profile.published_at >= 30.days.ago
    else
      self.users.include?(u)
    end
  end

  def mark_unpublish_info
    self.published_at = nil
    self.publisher = nil
    self.save!
  end
  
  def mark_publish_info
    self.published_at = Time.now
    self.publisher = self.current_publisher
    self.save!
  end
  
end
