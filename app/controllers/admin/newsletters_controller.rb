class Admin::NewslettersController < AdminApplicationController

  before_filter :get_newsletter, :only => [:publish, :retract, :edit, :update, :delete, :show]
  before_filter :get_latest_items, :only => [:edit, :new]

  def delete
    @newsletter.destroy
    flash[:notice] = "Newsletter deleted"
    redirect_to newsletters_path    
  end
  
  def publish
    @newsletter.current_publisher = @current_user
    @newsletter.publish!
    flash[:notice] = "Newsletter published"
    redirect_to newsletters_path
  end
  
  def retract
    @newsletter.retract!
    flash[:notice] = "Newsletter unpublished"
    redirect_to newsletters_path
  end
  
  def new
    @newsletter = Newsletter.new
  end
  
  def update
    if params["cancel"]
      flash[:notice]="Newsletter cancelled"
      redirect_back_or_default newsletters_path
    else
      @newsletter.update_attributes(params[:newsletter])
      if @newsletter.save
        flash[:notice] = "Newsletter saved"
        redirect_to newsletters_path
      else
        flash[:error] = "There were some errors saving this newsletter"
        render :action => "edit" 
      end
    end    
  end
  
  def create
    if params["cancel"]
      flash[:notice]="Newsletter cancelled"
      redirect_back_or_default newsletters_path
    else  
      @newsletter = Newsletter.new(params[:newsletter])
      @newsletter.author_id = @current_user.id
      if @newsletter.save
        flash[:notice] = "Newsletter saved"
        redirect_to newsletters_path
      else
        flash[:error] = "There were some errors saving this newsletter"
        render :action => "new" 
      end
    end
  end
  
  def index
    @newsletters = Newsletter.find(:all, :order => "created_at desc") 
  end
  
  private
  def get_newsletter
    @newsletter = Newsletter.find(params[:id])
  end
  def get_latest_items
    @latest_special_offers = SpecialOffer.latest.published
  end
end
