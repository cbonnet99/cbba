class Payment < ActiveRecord::Base
  DEFAULT_TYPE = "full_member"
  TYPES = {:full_member => {:payment_type => "new", :title => "Full membership for 1 year", :amount => 9999 },
    :renew_full_member => {:payment_type => "renewal", :title => "Renewal of full membership for 1 year", :amount => 19999 }
  }

  belongs_to :user
  has_one :order
  has_many :transactions, :class_name => "PaymentTransaction"

  attr_accessor :card_number, :card_verification

  validate_on_update :validate_card

  named_scope :pending, :conditions => "status ='pending'"
  named_scope :renewals, :conditions => "payment_type = 'renewal'"

  def purchase
    response = GATEWAY.purchase(amount, credit_card, purchase_options)
    logger.debug "============ response: #{response.inspect}"
    transactions.create!(:action => "purchase", :amount => amount, :response => response)
    if response.success?
      update_attribute(:status, "completed")
      user.member_since = Time.now if user.member_since.nil?
      if user.member_until.nil?
        user.member_until = 1.year.from_now
      else
        user.member_until += 1.year
      end
      user.save!
      user.activate! unless user.active?
    end
    response.success?
  end

  def purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name     => "#{first_name} #{last_name}",
        :address1 => address1,
        :city     => city,
        :country  => "NZ"
      }
    }
  end

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
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
end
