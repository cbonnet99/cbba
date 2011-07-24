require File.dirname(__FILE__) + '/../test_helper'

class NewsDigestTest < ActiveSupport::TestCase
  def test_create_new
    user = Factory(:user)
    older_article = Factory(:article, :state => "published", :published_at => 3.weeks.ago, :approved_at => 2.weeks.ago)
    more_recent_article = Factory(:article, :state => "published", :published_at => 1.week.ago, :approved_at => 2.days.ago)
    unapproved_article = Factory(:article, :state => "published", :published_at => 1.week.ago, :approved_at => nil)
    
    news_digest = NewsDigest.create_new
    
    assert news_digest.articles.include?(more_recent_article)
    assert !news_digest.articles.include?(older_article)
    assert !news_digest.articles.include?(unapproved_article)
  end
end
