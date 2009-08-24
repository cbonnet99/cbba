xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "BeAmazing articles"
    xml.description "Latest articles from BeAmazing"
    xml.link articles_url(:format => :rss)
    
    for article in @articles
      xml.item do
        xml.title article.title
        if article.class.to_s == "HowTo"
          xml.description article.summary
        else
          xml.description article.lead
        end
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link article_url(article, :format => :rss)
        xml.guid article_url(article, :format => :rss)
      end
    end
  end
end