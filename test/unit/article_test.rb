require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase

  def test_for_tag
    yoga = articles(:yoga)
    my_articles = Article.for_tag("yoga")
    assert_equal 1, my_articles.size
    assert_equal yoga.title, my_articles.first.title
  end
	def test_slug_length
		cyrille = users(:cyrille)
		new_article = Article.create(:title => "This is a long title that should be shorter",
			:body => "This is a test", :author => cyrille  )
		assert new_article.slug.size <= Article::MAX_LENGTH_SLUG
	end
	def test_slug_length
		long = articles(:long)
		assert long.slug.size <= Article::MAX_LENGTH_SLUG
	end
end
