class Order < ActiveRecord::Base
	include AASM
  belongs_to :user
  has_many :order_items
  has_one :payment
  
  before_create :check_whole_package
  before_update :check_whole_package
  after_create :create_payment
  after_update :update_amount
  
  aasm_column :state
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :paid
  aasm_event :mark_as_paid do
    transitions :from => :pending, :to => :paid
  end

  named_scope :not_expired, :conditions => ["created_at > ?", 1.year.ago], :order => "created_at"  
  named_scope :not_expiring, :conditions => ["created_at > ? and created_at < ?", 1.year.ago, 1.year.ago-7.days], :order => "created_at"  
  
  def check_whole_package
    if self.whole_package?
      self.photo = true
      self.highlighted = true
      self.special_offers = 1 if self.special_offers == 0 || self.special_offers.nil?
      self.gift_vouchers = 1 if self.gift_vouchers == 0 || self.gift_vouchers.nil?
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
    if whole_package?
      res << "the whole package"
    else
      res << "a photo " if photo?
      res << "a highlighted profile " if highlighted?
      if (special_offers.blank? || special_offers == 0)
        res << "#{help.pluralize(special_offers, 'special offer')}"
      end
      if (gift_vouchers.blank? || gift_vouchers == 0)
        res << "#{help.pluralize(gift_vouchers, 'gift voucher')}"
      end
    end
    return res
  end
  
  def compute_amount
    if whole_package?
      amount = 7500
      if self.special_offers.nil?
        self.special_offers = 1
      end
      amount += 1500*(self.special_offers-1)
      if self.gift_vouchers.nil?
        self.gift_vouchers = 1
      end
      amount += 1500*(self.gift_vouchers-1)
    else
      amount = 0
      if photo?
        amount += 3000
      end
      if highlighted?
        amount += 3000
      end
      if !self.special_offers.nil?
        amount += 1500*self.special_offers
      end
      if !self.gift_vouchers.nil?
        amount += 1500*self.gift_vouchers
      end
    end
    return amount
  end
  
  def create_payment
    Payment.create(:user_id => user.id, :amount => self.compute_amount, :payment_card_type => "credit_card",
    :first_name => user.first_name, :last_name => user.last_name, :address1 => user.address1,
    :city => user.city, :order_id => self.id )
  end
    
end
