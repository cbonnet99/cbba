class Admin::PaymentsController < AdminApplicationController
  def index
    @payments = Payment.find(:all, :order => "created_at desc" )
  end
  
  def mark_as_paid
    @payment = Payment.find(params[:id])
    @payment.mark_as_paid!
    flash[:notice] = "The payment has been marked as paid"
    redirect_to :action => "index" 
  end
end
