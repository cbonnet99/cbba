class BlogSubcategoriesController < ApplicationController
  def show
    @blog_subcategory = BlogSubcategory.find_by_slug(params[:id])
    @articles = if @blog_subcategory.nil?
      []
    else
      @blog_subcategory.articles.find(:all, :conditions => "state = 'published'", :order => "published_at desc", :limit => 20)
    end
  end

end
