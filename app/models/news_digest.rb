require File.dirname(__FILE__) + '/../../lib/helpers'

class NewsDigest < ActiveRecord::Base
  
  MAX_ARTICLES = 12
  
  attr_accessor :body
  
  def self.create_new
    articles = Article.approved.all(:limit => MAX_ARTICLES)
    news_digest = NewsDigest.create(:title => "BeAmazing News Digest #{Time.now.to_date}")
    news_digest.body = "Thanks for subscribing via <a href='http://www.beamazing.co.nz'>http://www.beamazing.co.nz</a> or <a href='http://www.zingabeam.com'>http://www.zingabeam.com</a>
    <strong>As promised</strong>, landing in your inbox are the latest articles published by Coaches, Trainers and Speakers over last couple of weeks - <strong>their passion, knowledge and expertise shared for free with you!</strong>
    From the team at BeAmazing, <strong>Enjoy!</strong><br/>
    ---<br/>
    <h3 style='color:#000; font-size:16px;font-weight:bold;'>Latest Articles<h3>"
    articles.each do |article|
      ArticlesDigest.create(:news_digest => news_digest, :article => article)
      news_digest.body << "<h4 style='color:#20ACCD; font-size:18px;font-weight:bold;><a href='http://#{help.site_url(article.author)}/amazing-articles/#{article.author.slug}/#{article.slug}'>#{article.title}</a></h4>"
      news_digest.body << "<h5 style='color:#000; font-size:14px;font-weight:bold;>by #{article.author.name} [#{article.author.location}]</h5>"
      news_digest.body << "<br/>"
      news_digest.body << "<p>Blog Categories: #{article.blog_categories.map(&:name).to_sentence}</p>"
      news_digest.body << "<p>#{article.lead}</p>"
    end
    return news_digest
  end
end
