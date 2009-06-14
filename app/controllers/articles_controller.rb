class ArticlesController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show]
	after_filter :store_location, :only => [:show]

	def unpublish
    @article = current_user.articles.find(params[:id])
		@article.remove!
		flash[:notice] = "Article is no longer published"
    redirect_back_or_default root_url

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this article"
      redirect_back_or_default root_url
	end

	def publish
    @article = current_user.articles.find(params[:id])
		@article.publish!
		flash[:notice] = "Article successfully published"
    redirect_back_or_default root_url

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this article"
      redirect_back_or_default root_url
	end
  
  def index
    @articles = Article.published
    @how_tos = HowTo.published
    
    @all_articles = @articles.concat(@how_tos)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @all_articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    get_selected_user
    if @selected_user.nil?
      flash[:error]="Sorry, this article could not be found"
      redirect_to user_articles_path
    else
      @article = @selected_user.find_article_for_user(params[:id], current_user)
      if @article.nil?
        flash[:error]="Sorry, this article could not be found"
        if @selected_user == current_user
          redirect_to user_articles_path
        else
          redirect_to articles_path
        end
      end      
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new
    #default to user's main expertise
    @article.subcategory1_id = current_user.subcategories.first.id unless current_user.subcategories.blank?
		get_subcategories

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find_by_author_id_and_id(current_user.id, params[:id])
#		@article.load_subcategories
		get_subcategories
  end

  # POST /articles
  # POST /articles.xml
  def create
    if params["cancel"]
      flash[:notice]="Article cancelled"
      redirect_back_or_default user_articles_path
    else  
      @article = Article.new(params[:article])
      @article.author_id = @current_user.id
      get_subcategories
      respond_to do |format|
        if @article.save
          if params["save_as_draft"]
            flash[:notice] = 'Your draft article was successfully saved.'
          else
            @article.publish!
            flash[:notice] = 'Your article was successfully saved and published.'
          end
          format.html { redirect_to(articles_show_path(@article.author.slug, @article.slug)) }
          format.xml  { render :xml => @article, :status => :created, :location => @article }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    get_subcategories

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(articles_show_path(@article.author.slug, @article.slug)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    if current_user.author?(@article) && @article.draft?
      @article.destroy
      flash[:notice] = "The article was deleted"
    else
      flash[:error] = "You cannot delete this article"
    end
    redirect_to(user_articles_path)
  end
end
