class RemoveHtmlFromLeads < ActiveRecord::Migration
  def self.up
    Article.all.each do |a|
      a.lead = a.lead.gsub(/<\/?[^>]*>/,"")
      a.save!
    end
    
    HowTo.all.each do |h|
      h.summary = h.summary.gsub(/<\/?[^>]*>/,"")
      h.save!
    end
    
  end

  def self.down
  end
end
