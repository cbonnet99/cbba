class Admin::MassEmailsController < AdminApplicationController

  before_filter :mass_email, :except => [:new, :create, :index]
  before_filter :get_newsletters, :only => [:edit, :create, :new]
   
  def copy
    @new_mass_email = MassEmail.create!(:subject => @mass_email.subject, :body => @mass_email.body,
    :creator => current_user, :email_type => @mass_email.email_type)
  end

  def index
    @mass_emails = MassEmail.find(:all, :order => "updated_at desc" )
  end

  def edit
    @email_types = MassEmail::TYPES
  end

  def new
    @mass_email = MassEmail.new
    @email_types = MassEmail::TYPES
  end

  def create
    @mass_email = MassEmail.new(params[:mass_email])
    @mass_email.creator = current_user
    if @mass_email.save
      flash[:notice] = "Successfully created email."
      redirect_to @mass_email
    else
      @email_types = MassEmail::TYPES
      render :action => 'new'
    end
  end

  def update
    if @mass_email.update_attributes(params[:mass_email])
      if @mass_email.no_recipients?
        flash[:notice] = "Successfully updated email."
      else
        if params["send"]
          @mass_email.deliver
          flash[:notice] = "Sending emails."
        else
          flash[:error]="There was an error, please contact administrator (your email cannot be sent)"
        end
      end
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
      res = @mass_email.deliver_test(current_user)
      if res.blank?    
        flash[:notice] = "The test email was sent"
      else
        flash[:warning] = res
      end
    else
      flash[:error] = "The fields: #{errors.to_sentence} could not be found"
    end
    redirect_to @mass_email
  end

  private

  def mass_email
    @mass_email = MassEmail.find(params[:id])
  end
  
  def get_newsletters
    @newsletters = Newsletter.find(:all, :conditions => ["state='published'"], :order => "published_at desc").collect{|n| [n.title, n.id]} 
  end
end
