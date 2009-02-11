class PaymentsController < ApplicationController
  before_filter :login_required

  def index
    @payments = current_user.payments.find(:all, :order => "status desc" )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = current_user.payments.find(params[:id])
    @payment.first_name = current_user.first_name
    @payment.last_name = current_user.last_name
    @payment.address1 = current_user.address1
    @payment.city = current_user.city
    if @payment.status != "pending"
      flash[:error] = "This payment is not pending"
      redirect_back_or_default root_url
    end
  end

  # PUT /payments/1
  # PUT /payments/1.xml
  def update
    @payment = current_user.payments.find(params[:id])

    params[:payment].merge!(:ip_address => request.remote_ip)
    if @payment.update_attributes(params[:payment])
      if @payment.purchase
        render :action => "thank_you"
      else
        logger.debug "======= #{@payment.errors.inspect}"
        render :action => 'edit'
      end
    else
      render :action => 'edit'
    end
  end
end
