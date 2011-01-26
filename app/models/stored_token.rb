class StoredToken < ActiveRecord::Base
  belongs_to :user
  has_many :payments
  
  before_save :store
  validate_on_update :validate_card
  validate_on_create :validate_card
  
  validates_presence_of :card_expires_on, :card_number, :first_name, :last_name
  
  attr_accessor :card_type, :card_number, :card_verification, :first_name, :last_name
  attr_protected :user, :user_id

  named_scope :expired, :conditions => ["card_expires_on < ?", Time.now.to_date]
  named_scope :not_expired, :conditions => ["card_expires_on >= ?", Time.now.to_date]
    
  def name
    "#{first_name} #{last_name}"
  end
  
  def obfuscated_card_number
    "#{"*"*14}#{last4digits}"
  end
  
  def extract_last4digits
    unless card_number.nil?
      self.last4digits = card_number[-4..card_number.length]
    end
  end

  def billing_id
    "#{user.id}-#{last4digits}"
  end
  
  def store
    response = GATEWAY.store(credit_card, :billing_id => billing_id)    
    logger.debug "============ response from DPS store: #{response.inspect}"    
    if response.success?
      self.billing_id = billing_id
    else
      self.errors.add(:base, "The credit card could not be stored")
      logger.error("A credit card could not be stored on DPS servers. Billing_id: #{billing_id}")
    end
  end
  
  def validate_card
    extract_last4digits
    credit_card.errors.full_messages.each do |message|
      errors.add_to_base message
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end

  def card_expired?
    !card_expires_on.nil? && card_expires_on < Time.now.to_date
  end
end
