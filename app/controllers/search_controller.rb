class SearchController < ApplicationController
  def search
  end

  def tag
    @articles = Article.for_tag(params[:id])
  end

end
