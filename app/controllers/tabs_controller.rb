class TabsController < ApplicationController
  
  before_filter :login_required, :except => [:select, :index]

  include ApplicationHelper

  def move_right
    @selected_tab = current_user.tabs.find_by_slug(params[:id])
    @user = current_user
    unless @selected_tab.nil?
      @selected_tab.move_lower
    end
    render :template => "users/show"
  end

  def move_left
    @selected_tab = current_user.tabs.find_by_slug(params[:id])
    @user = current_user
    unless @selected_tab.nil?
      @selected_tab.move_higher
    end
    render :template => "users/show"
  end

  def select
    @user = User.find_by_slug(params[:name])
    @selected_tab = @user.tabs.find_by_slug(params[:id])
  end
  
  def new
    get_subcategories
    @subcategories = current_user.remove_subcats(@subcategories)
    @selected_tab = Tab.new(:user_id => current_user.id)
    @user = current_user
    render :template => "users/show"
  end
  
  def create
    if params["cancel"]
      flash[:notice]="Tab creation cancelled"
      redirect_to expanded_user_url(current_user)
    else
      @count_tabs = current_user.tabs.size
      title = params[:title]
      content = params[:content]
      if @count_tabs >= Tab::MAX_PER_USER
        flash[:error] = "Sorry, you can only have #{Tab::MAX_PER_USER} tabs"
        redirect_to expanded_user_url(current_user)
      else
        @selected_tab = Tab.new(params[:tab])
        @selected_tab.user_id = current_user.id
        if @selected_tab.save
          flash[:notice] = "Your tab was saved"
          redirect_to expanded_user_tabs_url(current_user, @selected_tab.slug)
        else
          flash[:error] = "Your tab could not be saved"
          get_subcategories
          @subcategories = current_user.remove_subcats(@subcategories)
          render :action  => "new"
        end
      end
    end
  end

  def destroy
    tab_to_destroy_id = params[:id]
    selected_tab_id = tab_to_destroy_id == params[:tab_id] ? nil : params[:tab_id]
    unless tab_to_destroy_id.nil?
      if current_user.tabs.size == 1
        flash[:error] = "You cannot delete your last tab"
      else
        flash[:notice] = "Your tab was deleted"
        current_user.remove_tab(tab_to_destroy_id)
      end
    end
    redirect_to expanded_user_url(current_user)
  end

  def edit    
    @selected_tab = current_user.tabs.find_by_slug(params[:id]) || current_user.tabs.first
    get_subcategories(except_subcategories=current_user.subcategories.reject{|s| s == @selected_tab.subcategory})
    @selected_tab.set_contents
    @selected_tab.old_subcategory_id = @selected_tab.subcategory_id
    @user = current_user
    render :template => "users/show"
  end
  
  def update
    if params["cancel"]
      flash[:notice]="Tab update cancelled"
      redirect_to expanded_user_url(current_user)
    else
      @selected_tab = current_user.tabs.find_by_slug(params[:id])
      @user = current_user
      if @selected_tab.update_attributes(params[:tab])
        redirect_to expanded_user_tabs_url(current_user, @selected_tab.slug)
        flash[:notice] = "Your details have been updated"
      else
        get_subcategories(except_subcategories=current_user.subcategories.reject{|s| s == @selected_tab.subcategory})
        flash.now[:error]  = "There were some errors in your details."
        render :template => "users/show"
      end
    end
  end
end
