class PaymentsController < ApplicationController
  before_filter :admin_required, :only => [:index, :show]

  def index
    @payments = Payment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end

  # GET /payments/1
  # GET /payments/1.xml
  def show
    @payment = Payment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # GET /payments/new
  # GET /payments/new.xml
  def new
    payment_type = params[:payment_type]
    if payment_type.nil? || Payment::TYPES[payment_type.to_sym].nil?
      payment_type = Payment::DEFAULT_TYPE
    end
    @payment = current_user.payments.create!(:type => Payment::TYPES[payment_type.to_sym], :title => Payment::TYPES[payment_type.to_sym][:title],
      :amount => Payment::TYPES[payment_type.to_sym][:amount] )
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  def thank_you
    payment_type = params[:payment_type]
    if payment_type.nil? || Payment::TYPES[payment_type.to_sym].nil?
      payment_type = Payment::DEFAULT_TYPE
    end
    Payment.create(Payment::TYPES[payment_type.to_sym])
    #and add the role
    role = Role.find_by_name(payment_type)
    if role.nil?
      logger.error("In thank you page, role #{payment_type} could not be found")
    else
      current_user.membership_type = "full_member"
      current_user.save!
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find(params[:id])
  end

  # POST /payments
  # POST /payments.xml
  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        flash[:notice] = 'Payment was successfully created.'
        format.html { redirect_to(@payment) }
        format.xml  { render :xml => @payment, :status => :created, :location => @payment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.xml
  def update
    @payment = Payment.find(params[:id])

    params[:payment].merge!(:ip_address => request.remote_ip)
    if @payment.update_attributes(params[:payment])
      if @payment.purchase
        render :action => "success"
      else
        logger.debug "======= #{@payment.errors.inspect}"
        render :action => 'new'
      end
    else
      render :action => 'new'
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.xml
  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to(payments_url) }
      format.xml  { head :ok }
    end
  end
end
