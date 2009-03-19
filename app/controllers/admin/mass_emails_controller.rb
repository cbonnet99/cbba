class Admin::MassEmailsController < ApplicationController

  before_filter :mass_email, :except => [:new, :create, :index]

  def index
    @mass_emails = MassEmail.find(:all, :order => "updated_at desc" )
  end

  def new
    @mass_email = MassEmail.new
  end

  def create
    @mass_email = MassEmail.new(params[:mass_email])
    if @mass_email.save
      flash[:notice] = "Successfully created email."
      redirect_to @mass_email
    else
      render :action => 'new'
    end
  end

  def update
    if @mass_email.update_attributes(params[:mass_email])
      flash[:notice] = "Successfully updated email."
      redirect_to @mass_email
    else
      render :action => 'edit'
    end
  end

  def select_email_recipients
    @possible_recipients = MassEmail::RECIPIENTS
  end

  def send_test
    errors = @mass_email.unknown_attributes(current_user)
    if errors.blank?
      @mass_email.send_email(current_user)
      flash[:notice] = "The test email was sent"
    else
      flash[:error] = "The fields: #{errors.to_sentence} could not be found"
    end
    redirect_to @mass_email
  end

  private

  def mass_email
    @mass_email = MassEmail.find(params[:id])
  end

end
