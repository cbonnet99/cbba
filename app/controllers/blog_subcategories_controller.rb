class BlogSubcategoriesController < ApplicationController
  def show
    @blog_subcategory = BlogSubcategory.find_by_slug(params[:id])
    @articles = if @blog_subcategory.nil?
      []
    else
      @blog_subcategory.articles.published
    end
  end

end
