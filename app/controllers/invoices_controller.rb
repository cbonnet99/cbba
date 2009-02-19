class InvoicesController < ApplicationController

  before_filter :login_required
  
  def show
    if current_user.has_role?("Admin")
      @invoice = Invoice.find(params[:id])
    else
      @invoice = current_user.invoices.find(params[:id])
    end
    send_data(@invoice.pdf, :type => 'application/pdf', :filename => @invoice.filename, :disposition => 'inline')
  end
  
end
