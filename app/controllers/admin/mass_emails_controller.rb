class Admin::MassEmailsController < ApplicationController

  before_filter :mass_email, :only => [:edit, :show, :update, :send_test]

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

  def send_test
    arr = []
    errors = []
    @mass_email.body.split("%").each_with_index do |piece, index|
      if index.even?
        arr << piece
      else
        if current_user.public_methods.include?(piece)
          arr << current_user.send(piece.to_sym)
        else
          errors << piece
        end
      end
    end
    if errors.blank?
      UserMailer.deliver_mass_email_test(current_user, @mass_email.subject, arr.join(''))
      @mass_email.test_sent_at = Time.now
      @mass_email.test_sent_to = current_user
      @mass_email.save
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
