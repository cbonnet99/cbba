class BlogCategoriesController < ApplicationController
  def articles
    @blog_category = BlogCategory.find_by_slug(params[:id])
    @articles = @blog_category.articles.published
    @all_blog_categories = BlogCategory.all
  end
end
