class Order < ActiveRecord::Base
	include AASM
  belongs_to :user
  has_many :order_items
  has_one :payment
  
  after_create :create_payment
  after_update :update_amount
  before_validation :convert_package_to_features
  
  aasm_column :state
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :paid
  aasm_event :mark_as_paid do
    transitions :from => :pending, :to => :paid
  end
  
  attr_accessor :package
  
  named_scope :recently_expired, :conditions => ["created_at > ? and created_at < ?", 1.year.ago+7.days, 1.year.ago-7.days], :order => "created_at"  
  named_scope :not_expired, :conditions => ["created_at > ?", 1.year.ago], :order => "created_at"  
  named_scope :not_expiring, :conditions => ["created_at > ? and created_at < ?", 1.year.ago, 1.year.ago-7.days], :order => "created_at"  
  
  PRICE_SO = 750
  PRICE_GV = 750
  PRICE_PHOTO = 2900
  PRICE_HIGHLIGHT = 1000
  
  def expires_on
    if user.paid_photo_until.nil?
      1.year.from_now.to_date
    else
      user.paid_photo_until.advance(:months => 12).to_date
    end
  end
  
  def convert_package_to_features
    unless package.blank?
      self.photo = false
      self.highlighted = false
      self.special_offers = 0
      self.gift_vouchers = 0    
      case package
        when "premium" then
          self.photo = true
          self.highlighted = true
          self.special_offers = 2
          self.gift_vouchers = 2
      end
    end
  end
      
  def update_amount
    if valid?
      if payment.nil?
        create_payment
        self.reload
      end
      payment.update_attribute(:amount, self.compute_amount)
    end
  end
  
  def validate
    if !photo? && !highlighted? && !whole_package? && (special_offers.blank? || special_offers == 0) && (gift_vouchers.blank? || gift_vouchers == 0)
      errors.add_to_base("Please selected at least one feature")
    end
  end

  def description
    res = "Order for "
    features = []
    if whole_package?
      features << "the whole package"
    else
      features << "a photo" if photo?
      features << "a highlighted profile" if highlighted?
      if (special_offers.blank? || special_offers == 0)
        features << "#{help.pluralize(special_offers, 'trial session')}"
      end
      if (gift_vouchers.blank? || gift_vouchers == 0)
        features << "#{help.pluralize(gift_vouchers, 'gift voucher')}"
      end
    end
    return res + features.to_sentence
  end
  
  def compute_amount
    amount = 0
    if photo?
      amount += PRICE_PHOTO
    end
    if highlighted?
      amount += PRICE_HIGHLIGHT
    end
    if !self.special_offers.nil?
      amount += PRICE_SO*self.special_offers
    end
    if !self.gift_vouchers.nil?
      amount += PRICE_GV*self.gift_vouchers
    end
    return amount
  end
  
  def create_payment
    Payment.create(:user_id => user.id, :amount => self.compute_amount, :payment_card_type => "credit_card",
    :first_name => user.first_name, :last_name => user.last_name,
    :city => user.city, :order_id => self.id, :currency => user.country.currency)
  end
    
end
