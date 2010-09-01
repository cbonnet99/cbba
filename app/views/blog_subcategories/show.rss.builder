xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "BeAmazing content for #{@blog_subcategory.full_name}"
    xml.description "Latest content from BeAmazing for #{@blog_subcategory.full_name}"
    xml.link blog_subcategory_url(@blog_subcategory, :format => :rss)
    
    for article in @articles
      xml.item do
        xml.title article.title
        xml.description "#{white_list(article.lead)}<br/>#{white_list(article.body)}"
        xml.pubDate article.published_at.to_s(:rfc822)
        xml.author article.author.name
        xml.link stuff_url(article)
        xml.guid stuff_url(article)
      end
    end
  end
end