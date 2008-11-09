require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase
  fixtures :all

  def test_for_tag
    yoga = articles(:yoga)
    my_articles = Article.for_tag("yoga")
    assert_equal 1, my_articles.size
    assert_equal yoga.title, my_articles.first.title
  end
	def test_slug_length
		long = articles(:long)
		assert long.slug <= Article::MAX_LENGTH_SLUG
	end
end
