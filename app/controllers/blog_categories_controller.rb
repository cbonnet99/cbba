class BlogCategoriesController < ApplicationController
  def articles
    @blog_category = BlogCategory.find_by_slug(params[:id])
    @articles = @blog_category.articles.published.paginate(:page => params[:page])
    @all_blog_categories = BlogCategory.all
    @popular_articles = @country.articles.popular
  end
end
