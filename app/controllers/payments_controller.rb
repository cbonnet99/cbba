class PaymentsController < ApplicationController
  before_filter :login_required
  before_filter :get_payment, :only => [:edit, :edit_debit, :thank_you_direct_debit, :update] 
  ssl_required :edit, :update
  
  def thank_you_direct_debit
    UserMailer.deliver_thank_you_direct_debit(current_user, @payment)
  end

  def index
    @payments = current_user.payments.find(:all, :order => "status desc" )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment.update_attribute(:payment_type, "credit_card")
    @payment.first_name = current_user.first_name
    @payment.last_name = current_user.last_name
    @payment.address1 = current_user.address1
    @payment.city = current_user.city
    unless @payment.pending?
      flash[:error] = "This payment is not pending"
      redirect_back_or_default root_url
    end
  end

  def edit_debit
    @payment.update_attribute(:payment_type, "direct_debit")
    unless @payment.pending?
      flash[:error] = "This payment is not pending"
      redirect_back_or_default root_url
    end
  end

  # PUT /payments/1
  # PUT /payments/1.xml
  def update
    params[:payment].merge!(:ip_address => request.remote_ip)
    if @payment.update_attributes(params[:payment])
      if @payment.purchase
        render :action => Payment::REDIRECT_PAGES[@payment.payment_type.to_sym]
      else
        logger.debug "======= #{@payment.errors.inspect}"
        render :action => 'edit'
      end
    else
      render :action => 'edit'
    end
  end
  
  private
  
  def get_payment
    @payment = current_user.payments.find(params[:id])
  end
end

