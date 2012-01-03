class PaymentsController < ApplicationController
  before_filter :login_required
  before_filter :get_payment, :only => [:edit, :edit_debit, :edit_debit_charities, :thank_you_direct_debit, :update] 
  
  def thank_you_direct_debit
    UserMailer.deliver_thank_you_direct_debit(current_user, @payment)
  end

  def index
    @stored_tokens = current_user.stored_tokens
    @payments = current_user.payments.find(:all, :order => "status desc" )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end

  # GET /payments/1/edit
  def edit
    log_bam_user_event(UserEvent::STARTED_PAYMENT, "", "Credit card")
    @payment.update_attribute(:payment_card_type, "credit_card")
    @payment.first_name = current_user.first_name
    @payment.last_name = current_user.last_name
    @payment.city = current_user.city
    @payment.store_card = true
    unless @payment.pending?
      flash[:error] = "This payment is not pending"
      redirect_back_or_default root_url
    end
    set_pm
  end

  def edit_debit
    log_bam_user_event(UserEvent::STARTED_PAYMENT, "", "Direct debit")
    @payment.update_attribute(:payment_card_type, "direct_debit")
    unless @payment.pending?
      flash[:error] = "This payment is not pending"
      redirect_back_or_default root_url
    end
  end
  
  def edit_debit_charities
    @payment.update_attribute(:payment_card_type, "direct_debit")
    if @payment.pending?
      unless @payment.charity.blank?
        redirect_to :controller => "payments", :action => "edit_debit", :id => @payment.id
      end
    else
      flash[:error] = "This payment is not pending"
      redirect_back_or_default root_url
    end
  end

  # PUT /payments/1
  # PUT /payments/1.xml
  def update
    if params["cancel"]
      flash[:notice] = "Payment cancelled"
      @payment.destroy
      redirect_to expanded_user_url(current_user)
    else
      params[:payment].merge!(:ip_address => request.remote_ip)
      if @payment.update_attributes(params[:payment])
        if @payment.payment_card_type == "direct_debit"
          redirect_to :controller => "payments", :action => "edit_debit", :id => @payment.id
        else
          @gateway_response = @payment.purchase!
          if !@gateway_response.nil? && @gateway_response.success?
            log_bam_user_event(UserEvent::PAYMENT_SUCCESS, "", "#{@payment.order.description} for #{amount_view(@payment.total, @payment.currency)}")
            flash[:notice] = "Thank you for your payment. Your membership is now activated"
            redirect_to expanded_user_url(current_user)
          else
            log_bam_user_event(UserEvent::PAYMENT_FAILURE, "", "#{@gateway_response.try(:message)}")
            logger.debug "======= #{@payment.errors.inspect}"
            flash[:error] = "There was a problem processing your payment. #{@gateway_response.try(:message)}"
            render :action => 'edit'
          end
        end
      else
        flash[:error] = "There was a problem processing your payment"
        set_pm
        if @payment.payment_card_type == "direct_debit"
          render :action => 'edit_debit_charities'
        else
          render :action => "edit"
        end
      end
    end
  end
  
  private
  
  def set_pm
    if params[:pm] != "existing" && params[:pm] != "different"
      if current_user.has_current_stored_tokens?
        @pm = :existing
      else
        @pm = :different
      end
    else
      @pm = params[:pm].to_sym
    end    
  end
  
  def get_payment
    @payment = current_user.payments.find(params[:id])
  end
end

