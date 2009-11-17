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

  def create
    @count_tabs = current_user.tabs.size
    title = params[:title] || "Tab #{@count_tabs+1}"
    content = params[:content] || "Content here"
    @tab = current_user.add_tab(title, nil, content)
    if @tab.nil?
      flash[:error] = "Sorry, you can only have #{Tab::MAX_PER_USER} tabs"
      redirect_to expanded_user_url(current_user)
    else
      redirect_to action_tab_with_id_url(@tab.slug, :action => "edit" )
    end
  end

  def destroy
    tab_to_destroy_id = params[:id]
    selected_tab_id = tab_to_destroy_id == params[:tab_id] ? nil : params[:tab_id]
    unless tab_to_destroy_id.nil?
      current_user.remove_tab(tab_to_destroy_id)
    end
    redirect_to expanded_user_url(current_user)
  end

  def edit
    @selected_tab = current_user.tabs.find_by_slug(params[:id])
    @user = current_user
    render :template => "users/show"
  end

  def update
    @selected_tab = current_user.tabs.find_by_slug(params[:id])
    @user = current_user
    if @selected_tab.update_attributes(params[:tab])
      @selected_tab.update_attribute(:slug, @selected_tab.title.parameterize)
      redirect_to expanded_user_tabs_url(current_user, @selected_tab.slug)
      flash[:notice] = "Your details have been updated"
    else
      flash.now[:error]  = "There were some errors in your details."
      render :template => "users/show"
    end

  end

end
