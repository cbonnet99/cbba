xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "BeAmazing articles"
    xml.description "Latest articles from BeAmazing"
    xml.link articles_url(:format => :rss)
    
    for article in @articles
      xml.item do
        xml.title article.title
        xml.description article.lead
        xml.pubDate article.published_at.to_s(:rfc822)
        xml.author article.author.name
        xml.link stuff_url(article)
        xml.guid stuff_url(article)
      end
    end
  end
end