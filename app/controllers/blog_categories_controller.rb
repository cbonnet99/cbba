class BlogCategoriesController < ApplicationController
  def articles
    @blog_category = BlogCategory.find_by_slug(params[:id])
    @articles = @blog_category.articles.published.paginate(:page => params[:page])
    @all_blog_categories = BlogCategory.all
    @blog_cat = BlogCategory.random
    @blog_articles = @country.random_blog_articles(@blog_cat)
  end
end
