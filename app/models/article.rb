class Article < ActiveRecord::Base
  include Slugalizer
  
  acts_as_taggable
  
  belongs_to :author, :class_name => "User" 
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 80

  MAX_LENGTH_INTRODUCTION = 100
	MAX_LENGTH_SLUG = 20

  def self.for_tag(name)
    query = "select a.* from articles a, taggings, tags"
    query << " where taggings.taggable_type = 'Article'"
    query << " and taggings.tag_id = tags.id"
    query << " and tags.name = ?"
    query << " and taggings.taggable_id = a.id"
    Article.find_by_sql([query, name])
  end
  
  def to_param  
     "#{id}-#{Slugalizer.slugalize(title)}"
  end  
  
  def introduction
    if self.title.size <= MAX_LENGTH_INTRODUCTION
      return self.title
    else
      words = self.title.split(" ")
      words.pop
      while words.join(" ").size > MAX_LENGTH_INTRODUCTION do
         words.pop
      end
      
      return words.join(" ") + "..."
    end
  end
end
