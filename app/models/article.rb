require File.dirname(__FILE__) + '/../../lib/helpers'

class Article < ActiveRecord::Base
  include Slugalizer
	include SubcategoriesSystem
  include WorkflowSystem
  
  acts_as_taggable
	
  belongs_to :author, :class_name => "User"
	has_many :articles_subcategories
	has_many :subcategories, :through => :articles_subcategories
	has_many :articles_categories
	has_many :categories, :through => :articles_categories
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 80

	after_create :create_slug, :create_intro
#	after_update :create_slug, :create_intro

  MAX_LENGTH_INTRODUCTION = 100
	MAX_LENGTH_SLUG = 20

  def path_method
    "article_path"
  end

	def self.find_all_by_subcategories(*subcategories)
		Article.find_by_sql(["select a.* from articles a, articles_subcategories asub where a.id = asub.article_id and asub.subcategory_id in (?)", subcategories])
	end

	def self.count_all_by_subcategories(*subcategories)
		User.count_by_sql(["select count(a.*) as count from articles a, articles_subcategories asub where a.id = asub.article_id and asub.subcategory_id in (?)", subcategories])
	end

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

	def create_intro
		self.update_attribute(:introduction, computed_intro)
	end

	def computed_intro
		help.shorten_string(body, MAX_LENGTH_INTRODUCTION)
	end

  def introduction
		introduction ||= computed_intro
  end
	def self.id_from_url(url)
		unless url.nil?
			url.split("-").first.to_i
		end
	end

	def self.slug_from_url(url)
		unless url.nil?
			a = url.split("-")
			a.shift
			a.join("-")
		end
	end

end
