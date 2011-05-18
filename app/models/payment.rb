require 'xero_gateway'

class ErrorResponse < Struct.new(:message)
  def success?
    false
  end
  def message
    message
  end
end

class Payment < ActiveRecord::Base  
	include Authorization::AasmRoles::StatefulRolesInstanceMethods
	include AASM
  
  GST = 1500  
  
  
  aasm_column :status
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :completed, :enter => :finalize_complete

  aasm_event :complete do
    transitions :from => :pending, :to => :completed
  end

  belongs_to :stored_token
  belongs_to :user
  has_one :invoice
  has_many :transactions, :class_name => "PaymentTransaction"
  belongs_to :charity
  has_many :paid_features
  belongs_to :order
  
  attr_accessor :card_number, :card_verification, :store_card, :stored_token_id

  validate_on_update :validate_card

  before_create :compute_gst, :set_defaults

  named_scope :pending, :conditions => "status ='pending'"
  named_scope :notified, :conditions => "notified_at IS NOT NULL"
  named_scope :not_notified, :conditions => "notified_at IS NULL"
  named_scope :renewals, :conditions => "payment_type = 'renewal'"
  named_scope :resident, :conditions => "payment_type = 'resident_expert'"
  named_scope :resident_renewals, :conditions => "payment_type = 'resident_expert_renewal'"
    
  def set_defaults
    self.discount = 0 if self.discount.nil?
  end
  
  def create_invoice
    #create invoice internally
    my_invoice = Invoice.create!(:payment_id => self.id )
    update_attribute(:invoice_number, my_invoice.invoice_number)
    update_attribute(:code, "#{user.id}-#{self.invoice_number}")
    
    #create draft invoice in Xero    
    invoice = XeroGateway::Invoice.new({
      :invoice_type => "ACCREC",
      :due_date => 1.week.from_now,
      :invoice_number => self.invoice_number,
      :reference => self.code,
      :tax_inclusive => true,
      :includes_tax => true,
      :sub_total => '%.2f' % (amount/100.0) ,
      :total_tax => '%.2f' % (gst/100.0),
      :total => '%.2f' % ((amount+gst)/100.0)
    })
    invoice.contact = XeroGateway::Contact.new(:name => self.user.name)
    invoice.contact.phone.number = self.user.phone
    invoice.contact.address.line_1 = self.user.address1    
    invoice.line_items << XeroGateway::LineItem.new(
      :description => self.title,
      :unit_amount => '%.2f' % (amount/100.0),
      :tax_amount => '%.2f' % (gst/100.0),
      :line_amount => '%.2f' % (amount/100.0),
      :tracking_category => "Internet subscription",
      :tracking_option => self.title
    )
    logger.debug("Creating invoice number #{invoice.invoice_number}")
  	$xero_gateway.create_invoice(invoice)
  end

  def mark_as_paid!
    self.complete!
    #send an email with invoice
    if invoice.nil?
      create_invoice
      self.reload
      logger.error("Invoice was nil for payment: #{self.id} (user: payment: #{self.user.name}), recreated invoice (no action required, but please investigate: double invoices might have been created.)")
    end
    unless self.order.nil?
      self.order.mark_as_paid!
    end
    if !self.order.nil?
      if self.order.photo?
        self.user.paid_photo = true
        self.user.paid_photo_until = (self.user.paid_photo_until || Time.now)+1.year
      end
      if self.order.highlighted?
        self.user.paid_highlighted = true
        self.user.paid_highlighted_until = (self.user.paid_highlighted_until || Time.now)+1.year
      end
      if !self.order.special_offers.nil? && self.order.special_offers > 0
        self.user.paid_special_offers = (self.user.paid_special_offers || 0) + self.order.special_offers
        self.user.paid_special_offers_next_date_check = (self.user.paid_special_offers_next_date_check.nil? || self.user.paid_special_offers_next_date_check < Time.now.to_date) ? Time.now+1.year : self.user.paid_special_offers_next_date_check
      end
      if !self.order.gift_vouchers.nil? && self.order.gift_vouchers > 0
        self.user.paid_gift_vouchers = (self.user.paid_gift_vouchers || 0) + self.order.gift_vouchers
        self.user.paid_gift_vouchers_next_date_check = (self.user.paid_gift_vouchers_next_date_check.nil? || self.user.paid_gift_vouchers_next_date_check < Time.now.to_date) ? Time.now+1.year : self.user.paid_special_offers_next_date_check
      end
      self.user.save!
    end    
    UserMailer.deliver_payment_invoice(user, self, self.invoice)
  end

  def last4digits
    unless card_number.nil?
      card_number[-4..card_number.length]
    end
  end

  def purchase!
    if self.stored_token_id.nil?
      response = GATEWAY.purchase(total, credit_card, purchase_options)
      if response.success? && self.store_card == "1"
        token = user.stored_tokens.create(:card_number => card_number, :first_name => first_name, :last_name => last_name, :last4digits => last4digits, :card_expires_on => card_expires_on.end_of_month)
      end
    else
      token = self.user.stored_tokens.find(self.stored_token_id)
      if token.nil?
        return ErrorResponse.new("No token for ID: #{self.stored_token_id}")
      else
        response = GATEWAY.purchase(total, token.billing_id , purchase_options)
      end
    end
    logger.debug "============ response from DPS purchase: #{response.inspect}"
    transactions.create!(:action => "purchase", :amount => total, :response => response)
    if response.success?
      self.mark_as_paid!
    end
    return response
  end

  def purchase_options
    {
      :ip => ip_address,
      :input_currency => self.user.try(:country).try(:currency).try(:upcase),
      :description => "#{user.email} - #{payment_type}",
      :billing_address => {
        :name     => "#{first_name} #{last_name}",
        :address1 => address1,
        :city     => city,
        :country  => self.user.try(:country).try(:country_code).try(:upcase)
      }
    }
  end

  def validate_card
    unless payment_card_type == "direct_debit" || !self.stored_token_id.nil? || credit_card.valid?
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
  def finalize_complete
    create_invoice
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
      if payment_type == "new"
        #reset publication information
        unless user.user_profile.nil?
          user.user_profile.published_at = nil
          user.user_profile.approved_at = nil
          user.user_profile.approved_by_id = nil
          user.user_profile.save!          
        end
      end
    end
    if payment_type == "resident_expert" || payment_type == "resident_expert_renewal"
      user.resident_since = Time.now if user.resident_since.nil?
      user.member_since = Time.now if user.member_since.nil?
      if user.resident_until.nil?
        user.resident_until = 1.year.from_now
      else
        user.resident_until += 1.year
      end
      if user.member_until.nil?
        user.member_until = 1.year.from_now
      else
        user.member_until += 1.year
      end
      
    end
    user.save!
  end

  def total
    self.amount+self.gst
  end

  def compute_gst
    if self.user.country.gst?
      my_divmod = (Payment::GST*self.amount).divmod(10000)
      diviseur = my_divmod[0]
      reste = my_divmod[1]
      diviseur += 1 if reste > 5000
      self.gst = diviseur
    else
      self.gst = 0
    end
  end

  def completed?
    !self.status.nil? && self.status == "completed"
  end

  def pending?
    !self.status.nil? && self.status == "pending"
  end
end
