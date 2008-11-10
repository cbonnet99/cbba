require File.dirname(__FILE__) + '/../../lib/helpers'

class Article < ActiveRecord::Base
  include Slugalizer
  
  acts_as_taggable
  
  belongs_to :author, :class_name => "User" 
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 80

	after_create :create_slug

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

	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		Slugalizer.slugalize(help.shorten_string(title, MAX_LENGTH_SLUG, ""))
	end

	def slug
		#just in case the slug is nil (for fixtures, for instance)
		slug ||= computed_slug
	end

  def to_param  
     "#{id}-#{slug}"
  end  
  
  def introduction
		introduction ||= help.shorten_string(body, MAX_LENGTH_INTRODUCTION)
  end
end
