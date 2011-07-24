require File.dirname(__FILE__) + '/../../lib/helpers'

class NewsDigest < ActiveRecord::Base
  
  MAX_ARTICLES = 12
  
  has_many :articles_digests, :foreign_key => "digest_id" 
  has_many :articles, :through => :articles_digests 
  has_many :user_emails
  
  validates_presence_of :title
  
  def self.create_new
    articles = Article.approved.all(:limit => MAX_ARTICLES)
    news_digest = NewsDigest.create(:title => "BeAmazing News Digest #{Time.now.to_date}")
    articles.each do |article|
      ArticlesDigest.create(:digest_id => news_digest.id, :article => article)
    end
    return news_digest
  end
end
