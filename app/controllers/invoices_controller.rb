class InvoicesController < ApplicationController

  before_filter :login_required
  
  def show
      @invoice = Invoice.find(params[:id])
      if !current_user.admin? && !current_user.invoices.include?(@invoice)
        flash[:error] = "You cannot access this invoice"
      else
        send_data(@invoice.pdf, :type => 'application/pdf', :filename => @invoice.filename, :disposition => 'inline')
      end
  end
  
end
