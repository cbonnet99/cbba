require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase

	def test_count_reviewable
		assert_equal 1, Article.count_reviewable
	end

	def test_find_all_by_subcategories
		courses = categories(:courses)
		articles = Article.find_all_by_subcategories(*courses.subcategories)
		assert articles.size > 0
	end

	def test_create
		yoga = subcategories(:yoga)
		new_article = Article.create(:title => "Test", :subcategory1_id => yoga.id  )
		assert_equal 1, new_article.subcategories.size
	end

	def test_url_extraction
		s = "692675549-article-with-a-very"
		assert_equal 692675549, Article.id_from_url(s)
		assert_equal "article-with-a-very", Article.slug_from_url(s)
	end

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
