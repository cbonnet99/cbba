class ArticlesController < ApplicationController
  
  before_filter :login_required, :only => [:new, :create, :destroy, :publish]
	after_filter :store_location, :only => [:show]

	def publish
    @article = Article.find(params[:id])
		if current_user.id == @article.author_id
			@article.publish!
			flash[:notice] = "Article successfully published"
		else
			flash[:error] = "You can not publish this article"
		end
		redirect_back_or_default root_url
	end

  def index
    @articles = Article..published

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new
		get_subcategories

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
		id = Article.id_from_url(params[:id])
    @article = Article.find_by_author_id_and_id(current_user.id, id)
#		@article.load_subcategories
		get_subcategories
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.author_id = @current_user.id
    get_subcategories
    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
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
        format.html { redirect_to(@article) }
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
