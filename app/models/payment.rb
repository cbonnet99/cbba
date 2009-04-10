require File.dirname(__FILE__) + '/../../lib/gateway'

class Payment < ActiveRecord::Base
  include Payable
  
  require 'xero_gateway'
  
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

  after_create :create_invoice

  def create_invoice
    #create invoice internally
    my_invoice = Invoice.create!(:payment_id => self.id )
    update_attribute(:invoice_number, my_invoice.invoice_number)
    update_attribute(:code, "#{user.id}-#{self.invoice_number}")
    
    #create draft invoice in Xero
    gateway = xero.gateway
    
    invoice = XeroGateway::Invoice.new({
      :invoice_type => "ACCREC",
      :due_date => 1.week.from_now,
      :invoice_number => self.invoice_number,
      :reference => self.code,
      :tax_inclusive => true,
      :includes_tax => false,
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

  	gateway.create_invoice(invoice)
  end

  def mark_as_paid
    self.complete!
    #send an email with invoice
    UserMailer.deliver_payment_invoice(user, self, self.invoice)    
  end

  def purchase
    response = GATEWAY.purchase(total, credit_card, purchase_options)
    logger.debug "============ response from DPS: #{response.inspect}"
    transactions.create!(:action => "purchase", :amount => total, :response => response)
    if response.success?
      self.mark_as_paid
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
