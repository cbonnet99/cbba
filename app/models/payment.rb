class Payment < ActiveRecord::Base
  DEFAULT_TYPE = "full_member"
  TYPES = {:full_member => {:payment_type => "new", :title => "12 month membership", :amount => 9900, :discount => 10000  },
    :renew_full_member => {:payment_type => "renewal", :title => "12 month membership renewal", :amount => 19900, :discount => 0 },
    :resident_expert => {:payment_type => "resident_expert", :title => "12 month resident expert membership", :amount => 35000, :discount => 34900 },
    :renew_resident_expert => {:payment_type => "resident_expert_renewal", :title => "12 month resident expert membership renewal", :amount => 69900, :discount => 0 }
  }
  REDIRECT_PAGES = {:new => "thank_you", :renewal => "thank_you_renewal", :resident_expert => "thank_you_resident_expert"}

  GST = 1250

  belongs_to :user
  has_one :invoice
  has_many :transactions, :class_name => "PaymentTransaction"
  has_one :expert_application

  attr_accessor :card_number, :card_verification

  validate_on_update :validate_card
  before_create :compute_gst

  named_scope :pending, :conditions => "status ='pending'"
  named_scope :renewals, :conditions => "payment_type = 'renewal'"

  def total
    amount+gst
  end

  def compute_gst
    my_divmod = (GST*amount).divmod(10000)
    diviseur = my_divmod[0]
    reste = my_divmod[1]
    diviseur += 1 if reste > 5000
    self.gst = diviseur

  end

  def completed?
    !status.nil? && status == "completed"
  end

  def pending?
    !status.nil? && status == "pending"
  end

  def purchase
    response = GATEWAY.purchase(total, credit_card, purchase_options)
    logger.debug "============ response from DPS: #{response.inspect}"
    transactions.create!(:action => "purchase", :amount => total, :response => response)
    if response.success?
      update_attribute(:status, "completed")
      #create invoice
      @invoice = Invoice.create(:payment_id => self.id )
      update_attribute(:invoice_number, @invoice.filename)
      if payment_type == "new" || payment_type == "renewal"
        user.member_since = Time.now if user.member_since.nil?
        if user.member_until.nil?
          user.member_until = 1.year.from_now
        else
          user.member_until += 1.year
        end
        #in case this is a free listing user upgrading...
        if user.free_listing?
          user.free_listing = false
          user.add_role("full_member")
        end
      end
      if payment_type == "resident_expert" || payment_type == "resident_expert_renewal"
        user.resident_since = Time.now if user.resident_since.nil?
        if user.resident_until.nil?
          user.resident_until = 1.year.from_now
        else
          user.resident_until += 1.year
        end
        if !user.resident_expert?
          user.free_listing = false
          user.add_role("resident_expert")
          subcat = expert_application.subcategory
          if !subcat.resident_expert.nil?
            logger.error("User: #{user.full_name} has paid to become resident expert on #{subcat.name}, but there is already an expert: #{subcat.resident_expert.full_name}")
          else
            subcat.update_attribute(:resident_expert_id, user.id)
          end
        end
      end
      user.save!
      user.activate! unless user.active?
      #finally send an email with invoice
      UserMailer.deliver_payment_invoice(user, self, @invoice)
    end
    response.success?
  end

  def purchase_options
    {
      :ip => ip_address,
      :description => "#{user.email} - #{payment_type}",
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
