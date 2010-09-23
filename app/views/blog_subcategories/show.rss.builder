xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "BeAmazing content for #{@blog_subcategory.try(:full_name)}"
    xml.description "Latest content from BeAmazing for #{@blog_subcategory.try(:full_name)}"
    xml.link @blog_subcategory.nil? ? "" : blog_subcategory_url(@blog_subcategory, :format => :rss)
    
    for article in @articles
      xml.item do
        xml.title "#{article.title}"
        xml.description "by #{author_link(article.author)}<br/>#{white_list(article.lead)}<br/>#{white_list(article.body)}<br/><% unless article.about.blank? %><h4>About the author</h4>
        <%= white_list article.about %><br/><%end%>#{author_link(article.author, 'Meet '+article.author.try(:name))}"
        xml.pubDate article.published_at.to_s(:rfc822)
        xml.author article.author.name
        xml.link stuff_url(article)
        xml.guid stuff_url(article)
      end
    end
  end
end