class HowTosController < ApplicationController

  before_filter :login_required, :only => [:new, :create, :destroy, :publish]
	after_filter :store_location, :only => [:show]

	def unpublish
    @how_to = current_user.how_tos.find(params[:id])
		@how_to.remove!
		flash[:notice] = "How to article is no longer published"
    redirect_back_or_default root_url

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this article"
      redirect_back_or_default root_url
	end

	def publish
    @how_to = current_user.how_tos.find(params[:id])
		@how_to.publish!
		flash[:notice] = "How to article successfully published"
    redirect_back_or_default root_url

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this article"
      redirect_back_or_default root_url
	end

  def index
    @how_tos = HowTo.published

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @how_tos }
    end
  end

  def show
    @how_to = HowTo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @how_to }
    end
  end

  def new
    @how_to = HowTo.new
    @how_to.step_label = "step"
    @how_to.how_to_steps.build
		get_subcategories

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @how_to }
    end
  end

  def edit
		id = HowTo.id_from_url(params[:id])
    @how_to = HowTo.find_by_author_id_and_id(current_user.id, id)
#		@how_to.load_subcategories
		get_subcategories
  end

  def create
    @how_to = HowTo.new(params[:how_to])
    @how_to.author_id = @current_user.id
    get_subcategories
    respond_to do |format|
      if @how_to.save
        flash[:notice] = 'HowTo was successfully created.'
        format.html { redirect_to(@how_to) }
        format.xml  { render :xml => @how_to, :status => :created, :location => @how_to }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @how_to.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @how_to = HowTo.find(params[:id])
        get_subcategories

    respond_to do |format|
      if @how_to.update_attributes(params[:how_to])
        flash[:notice] = 'HowTo was successfully updated.'
        format.html { redirect_to(@how_to) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @how_to.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @how_to = HowTo.find(params[:id])
    if current_user.author?(@how_to) && @how_to.draft?
      @how_to.destroy
      flash[:notice] = "The how to was deleted"
    else
      flash[:error] = "You cannot delete this how to"
    end
    redirect_to(user_how_tos_path)
  end
end
