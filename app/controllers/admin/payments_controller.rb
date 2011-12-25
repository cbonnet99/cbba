class Admin::PaymentsController < AdminApplicationController
  def index
    @payments = Payment.paginate(:all, :page => params[:page], :order => "created_at desc" )
  end
  
  def mark_as_paid
    @payment = Payment.find(params[:id])
    @payment.mark_as_paid!
    flash[:notice] = "The payment has been marked as paid"
    redirect_to :controller => "admin/payments", :action => "index", :id => nil 
  end

  def destroy
    @payment = Payment.find(params[:id])
    if @payment.pending?
      @payment.destroy
      flash[:notice] = "The payment was deleted"
    else
      flash[:error] = "Only pending payments can be deleted"
    end
    redirect_to :controller => "admin/payments", :action => "index", :id => nil 
  end
end
