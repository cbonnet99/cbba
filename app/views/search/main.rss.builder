xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "BeAmazing"
    xml.description "Latest activity from BeAmazing"
    xml.link main_url(:format => :rss)
    
    for stuff in @all
      xml.item do
        xml.title stuff.title
        xml.description stuff.summary
        xml.pubDate stuff.published_at.to_s(:rfc822)
        xml.link stuff_url(stuff)
        xml.guid stuff_url(stuff)
      end
    end
  end
end