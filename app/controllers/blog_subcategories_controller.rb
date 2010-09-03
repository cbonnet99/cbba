class BlogSubcategoriesController < ApplicationController
  def show
    @blog_subcategory = BlogSubcategory.find_by_slug(params[:id])
    @articles = @blog_subcategory.try(:articles).try(:published) || []
  end

end
