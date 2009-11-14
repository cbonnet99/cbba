class ArticlesController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show, :index_for_subcategory]
  before_filter :get_context, :except => :index 
	after_filter :store_location, :only => [:show]

  def index_for_subcategory
    @subcategory = Subcategory.find_by_slug(params[:subcategory_slug])
    @subcategory = Subcategory.first if @subcategory.nil?
    @articles = Article.find_all_by_subcategories(@subcategory)
    @how_tos = HowTo.find_all_by_subcategories(@subcategory)
    @all_articles = @articles.concat(@how_tos)
    @all_articles = @all_articles.sort_by(&:published_at).reverse
  end

	def unpublish
    # @article = current_user.articles.find(params[:id])
    @article = current_user.find_article(params[:id])
    
		@article.remove!
		flash[:notice] = "\"#{@article.title}\" is no longer published"
    redirect_with_context(articles_url)

		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not unpublish this article"
      redirect_with_context(articles_url)
	end

	def publish
    @article = current_user.find_article(params[:id])
		@article.publish!
		flash[:notice] = "\"#{@article.title}\" successfully published"
    redirect_with_context(articles_url)
    
		rescue ActiveRecord::RecordNotFound => e
			flash[:error] = "You can not publish this article"
      redirect_with_context(articles_url)
	end
  
  def index
    @context = "homepage"
    @articles = Article.published
    @how_tos = HowTo.published
    
    @all_articles = @articles.concat(@how_tos)
    @all_articles = @all_articles.sort_by(&:published_at).reverse
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @all_articles }
      format.rss{}
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    get_selected_user
    @selected_tab_id = "articles"
    if @selected_user.nil?
      flash[:error]="Sorry, this article could not be found"
      redirect_with_context(articles_url, nil)
    else
      @article = @selected_user.find_article_for_user(params[:id], current_user)
      if @article.nil?
        flash[:error]="Sorry, this article could not be found"
        redirect_with_context(articles_url, @selected_user) 
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
      redirect_to expanded_user_url(current_user, :selected_tab_id => @selected_tab_id)
    else  
      @article = Article.new(params[:article])
      @article.author_id = @current_user.id
      get_subcategories
      respond_to do |format|
        if @article.save
          if params["save_as_draft"]
            flash[:notice] = "\"#{@article.title}\" was successfully saved as a draft."
          else
            @article.publish!
            flash[:notice] = "\"#{@article.title}\" was successfully saved and published."
          end
          format.html { redirect_to(articles_show_url(@article.author.slug, @article.slug, :context => @context, :selected_tab_id => @selected_tab_id)) }
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
        flash[:notice] = "\"#{@article.title}\" successfully updated."
        format.html { redirect_to(articles_show_url(@article.author.slug, @article.slug, :context => @context, :selected_tab_id => @selected_tab_id)) }
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
    @title = @article.title
    if current_user.author?(@article)
      @article.destroy
      flash[:notice] = "\"#{@title}\" was deleted"
    else
      flash[:error] = "You cannot delete this article"
    end
    redirect_with_context(articles_url)
  end
end
