class HowTosController < ApplicationController

  before_filter :login_required, :only => [:new, :create, :destroy, :publish]
  before_filter :get_context
	after_filter :store_location, :only => [:show]

	def unpublish
    @how_to = current_user.find_how_to(params[:id])
		@how_to.remove!
		flash[:notice] = "\"#{@how_to.title}\" is no longer published"
    redirect_with_context(articles_url)

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this article"
      redirect_with_context(articles_url)
	end

	def publish
    @how_to = current_user.find_how_to(params[:id])
		@how_to.publish!
		flash[:notice] = "\"#{@how_to.title}\" successfully published"
    redirect_with_context(articles_url)

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this article"
      redirect_with_context(articles_url)
	end

  def show
    get_selected_user
    if @selected_user.nil?
      flash[:error]="Sorry, this 'how to' article could not be found"
      redirect_to user_howtos_path
    else
      @how_to = @selected_user.find_how_to_for_user(params[:id], current_user)
      if @how_to.nil?
        flash[:error]="Sorry, this 'how to' article could not be found"
        if @selected_user == current_user
          redirect_to user_howtos_path        
        else
          redirect_to how_tos_path        
        end
      end      
    end
  end

  def new
    @how_to = HowTo.new
    @how_to.step_label = "step"
    @how_to.how_to_steps.build
    #default to user's main expertise
    @how_to.subcategory1_id = current_user.subcategories.first.id unless current_user.subcategories.blank?
		get_subcategories

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @how_to }
    end
  end

  def edit
    @how_to = current_user.how_tos.find(params[:id])
#		@how_to.load_subcategories
		get_subcategories
  end

  def create
    if params["cancel"]
      flash[:notice]="'How to' article cancelled"
      redirect_to expanded_user_path(current_user, :selected_tab_id => @selected_tab_id)
    else  
      @how_to = HowTo.new(params[:how_to])
      @how_to.author_id = @current_user.id
      get_subcategories
      respond_to do |format|
        if @how_to.save
          if params["save_as_draft"]
            flash[:notice] = "\"#{@how_to.title}\" article was successfully saved in draft."
          else
            @how_to.publish!
            flash[:notice] = "\"#{@how_to.title}\" was successfully saved and published."
          end
          format.html { redirect_to(how_tos_show_path(@how_to.author.slug, @how_to.slug, :context => @context, :selected_tab_id => @selected_tab_id)) }
          format.xml  { render :xml => @how_to, :status => :created, :location => @how_to }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @how_to.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  def update
    @how_to = current_user.how_tos.find(params[:id])
        get_subcategories

    respond_to do |format|
      if @how_to.update_attributes(params[:how_to])
        flash[:notice] = "\"#{@how_to.title}\" was successfully updated."
        format.html { redirect_to(how_tos_show_path(@how_to.author.slug, @how_to.slug, :context => @context, :selected_tab_id => @selected_tab_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @how_to.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @how_to = current_user.how_tos.find(params[:id])
    @title = @how_to.title
    if current_user.author?(@how_to)
      @how_to.destroy
      flash[:notice] = "\"#{@title}\" was deleted"
    else
      flash[:error] = "You cannot delete this 'how to' article"
    end
    if @context == "profile"
      redirect_to expanded_user_path(current_user, :selected_tab_id => @selected_tab_id)
    else
      if @context == "review"
        redirect_to reviewer_path(:action => "index")
      else
        #homepage context is the default
        redirect_to articles_url
      end
    end
  end
end
