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
        xml.pubDate article.published_at.to_s(:rfc822)
        if article.class.to_s == "HowTo"
          xml.link how_tos_show_url(article.author.slug, article.slug)
          xml.guid how_tos_show_url(article.author.slug, article.slug)
        else
          xml.link articles_show_url(article.author.slug, article.slug)
          xml.guid articles_show_url(article.author.slug, article.slug)
        end
      end
    end
  end
end