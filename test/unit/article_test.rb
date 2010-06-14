require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase

  def test_unique_slugs
    user = Factory(:user)
    article1 = Factory(:article, :title => "This is a test", :author => user)
    article1.update_attributes(:title => "Other title")
    article2 = Factory(:article, :title => "This is a test", :author => user)
    assert_not_equal article1.slug, article2.slug
  end

  def test_shorten_string
    assert_equal "a"*20, help.shorten_string("a"*21, 20, "").parameterize
  end

  def test_unique_slugs_for_long_titles
    user = Factory(:user)
    article1 = Factory(:article, :title => "a"*Article::MAX_LENGTH_SLUG+"1", :author => user)
    article2 = Factory(:article, :title => "a"*Article::MAX_LENGTH_SLUG+"2", :author => user)
    assert !article1.slug.blank?
    assert_not_equal article1.slug, article2.slug
  end

  def test_search_region
    welly = regions(:wellington)
    yoga = subcategories(:yoga)
    search_res = Article.search(yoga, nil, nil, welly)
    assert !search_res.blank?, "Search results should not be empty"
  end

  def test_search_city
    welly_city = districts(:wellington_wellington_city)
    yoga = subcategories(:yoga)
    search_res = Article.search(yoga, nil, welly_city, nil)
    assert !search_res.blank?
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
    assert_equal first_article, articles[3], "The first article should now be fourth"
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

	def test_create_slug
		yoga = subcategories(:yoga)
		new_article = Article.create(:title => "Empowering your ", :lead => "This is my lead", :body => "",
      :subcategory1_id => yoga.id, :author => users(:cyrille)  )
		assert_equal "empowering-your", new_article.slug
		new_article.update_attributes(:title => "Empowering your ")
		assert_equal "empowering-your", new_article.slug, "Slug shouldn't change on update"
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
