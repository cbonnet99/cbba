class BlogSubcategoriesController < ApplicationController
  def show
    @blog_subcategory = BlogSubcategory.find_by_slug(params[:id])
    @articles = @blog_subcategory.articles.published
  end

end
