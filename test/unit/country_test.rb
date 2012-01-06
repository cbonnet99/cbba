require File.dirname(__FILE__) + '/../test_helper'

class CountryTest < ActiveSupport::TestCase

  def test_random_blog_articles
    blog_category = blog_categories(:yourhealth)
    blog_subcat1 = Factory(:blog_subcategory, :blog_category => blog_category) 
    blog_subcat2 = Factory(:blog_subcategory, :blog_category => blog_category) 
    
    article = Factory(:article, :blog_subcategory1_id => blog_subcat1.id, :blog_subcategory2_id => blog_subcat2.id )
    
    random_blog_articles = countries(:nz).random_blog_articles(blog_category)
    
    assert random_blog_articles.include?(article)
    count_article = random_blog_articles.select{|a| a.id == article.id}.size
    assert_equal 1, count_article, "The article should only appear once"
  end
  
  def test_extract_country_code_from_host
    assert_equal countries(:nz), Country.extract_country_code_from_host("nz.zingabeam.com")
    assert_equal countries(:au), Country.extract_country_code_from_host("au.zingabeam.com")
  end

  def test_extract_country_code_from_host_default
    assert_equal countries(:au), Country.extract_country_code_from_host("www.zingabeam.com")
  end

  def test_featured_full_members
    cyrille = users(:cyrille)
    TaskUtils.rotate_users
    cyrille.reload
    assert_equal [cyrille], countries(:nz).featured_full_members
  end

end
