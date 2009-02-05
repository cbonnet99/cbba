class Payment < ActiveRecord::Base
  DEFAULT_TYPE = "full_member"
  TYPES = {:full_member => {:title => "Full membership for 1 year", :amount => 9999 },
            :renew_full_member => {:title => "Renewal of full membership for 1 year", :amount => 19999 }
  }

  belongs_to :user
  has_one :order
  has_many :transactions, :class_name => "PaymentTransaction"

  attr_accessor :card_number, :card_verification

  validate_on_update :validate_card

  def purchase
    response = GATEWAY.purchase(amount, credit_card, purchase_options)
    logger.debug "============ response: #{response.inspect}"
    transactions.create!(:action => "purchase", :amount => amount, :response => response)
    if response.success?
      update_attribute(:status, "completed")
      user.member_since = Time.now
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
