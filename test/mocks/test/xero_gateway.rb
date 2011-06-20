module XeroGateway
  class Gateway      
  
    def initialize(params)
    end
    
    def get_invoices(modified_since = nil)
      response = XeroGateway::Response.new
         invoice = XeroGateway::Invoice.new({
           :invoice_type => "ACCREC",
           :due_date => 1.month.from_now,
           :invoice_number => "YOUR INVOICE NUMBER",
           :reference => "YOUR REFERENCE (NOT NECESSARILY UNIQUE!)",
           :includes_tax => false,
           :sub_total => 1000,
           :total_tax => 125,
           :total => 1125
         })
         invoice.contact = XeroGateway::Contact.new(:name => "THE NAME OF THE CONTACT")
         invoice.contact.phone.number = "12345"
         invoice.contact.address.line_1 = "LINE 1 OF THE ADDRESS"    
         invoice.line_items << XeroGateway::LineItem.new(
           :description => "THE DESCRIPTION OF THE LINE ITEM",
           :unit_amount => 100,
           :tax_amount => 12.5,
           :line_amount => 125,
           :tracking_category => "THE TRACKING CATEGORY FOR THE LINE ITEM",
           :tracking_option => "THE TRACKING OPTION FOR THE LINE ITEM"
         )
      response.response_item << invoice
      return response
    end
    
    #To create Xero invoices on tests, the easiest is to delete this file temporarily...
    def create_invoice(invoice)
    end
  end
end