require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase

  def test_search_region
    welly = regions(:wellington)
    yoga = subcategories(:yoga)
    assert !Article.search(yoga, nil, nil, welly)
  end

  def test_search_city
    welly_city = districts(:wellington_wellington_city)
    yoga = subcategories(:yoga)
    assert !Article.search(yoga, nil, welly_city, nil)
  end

  def test_all_featured_articles
    money = how_tos(:money)
    articles = Article.all_featured_articles
    assert articles.size > 1
    first_article = articles.first
    # puts "articles BEFORE: #{articles.map(&:title).join(', ')}"
    TaskUtils.rotate_feature_ranks
    articles = Article.all_featured_articles
    # puts "articles AFTER: #{articles.map(&:title).join(', ')}"
    assert_equal first_article, articles[1], "The first article should now be second"
  end

  def test_publish
    yoga = articles(:yoga)
    yoga.publish!
  end

	def test_count_reviewable
		assert_equal 2, Article.count_reviewable
	end

	def test_find_all_by_subcategories
		courses = categories(:courses)
		articles = Article.find_all_by_subcategories(*courses.subcategories)
		assert articles.size > 0
	end

	def test_create
		yoga = subcategories(:yoga)
		new_article = Article.create(:title => "Test", :lead => "This is my lead", :body => "",
      :subcategory1_id => yoga.id, :author => users(:cyrille)  )
#    puts new_article.errors.inspect
		assert_equal 1, new_article.subcategories.size
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
