module XeroGateway
  class Gateway

    def initialize(params)
      puts "==== INIT"
    end
    
    def get_invoices(modified_since = nil)
      puts "======= INVOICES"
    end

    def create_invoice(invoice)
      puts "======= CREARE INVOICES"
    end
  end
end