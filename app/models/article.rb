require File.dirname(__FILE__) + '/../../lib/helpers'

class Article < ActiveRecord::Base
	include SubcategoriesSystem
  include Workflowable
  
  acts_as_taggable
	
  belongs_to :author, :class_name => "User", :counter_cache => true
	has_many :articles_subcategories
	has_many :subcategories, :through => :articles_subcategories
	has_many :articles_categories
	has_many :categories, :through => :articles_categories

  alias_attribute :body_or_lead, :lead
  
  validates_presence_of :title, :lead, :author
  validates_length_of :title, :maximum => 255
  validates_length_of :lead, :maximum => 500
  validates_length_of :body, :maximum => 100000
  validates_uniqueness_of :title, :scope => "author_id", :message => "is already used for another of your articles" 

	after_create :create_slug

	MAX_LENGTH_SLUG = 20

  def body_or_lead
    if lead.blank?
      body
    else
      lead
    end
  end

  def validate
    if subcategory1_id.blank?
      errors.add(:subcategory1_id, "^You must select at least one category")
    end
  end

  def self.all_articles(user)
    straight_articles = Article.find_all_by_author_id(user.id, :order => "state, updated_at desc")
    how_to_articles = HowTo.find_all_by_author_id(user.id, :order => "state, updated_at desc")
    articles = straight_articles + how_to_articles
    articles = articles.sort_by(&:updated_at)
    return articles.reverse!
  end

  def self.all_published_articles(user)
    straight_articles = Article.find_all_by_author_id_and_state(user.id, "published", :order => "published_at desc")
    how_to_articles = HowTo.find_all_by_author_id_and_state(user.id, "published", :order => "published_at desc")
    articles = straight_articles + how_to_articles
    articles = articles.sort_by(&:published_at)
    return articles.reverse!
  end

	def self.find_all_by_subcategories(*subcategories)
		Article.find_by_sql(["select a.* from articles a, articles_subcategories asub where a.state = 'published' and a.id = asub.article_id and asub.subcategory_id in (?)", subcategories])
	end

  def self.all_newest_articles
    newest_straight_articles = Article.find(:all, :conditions => "state='published'", :order => "published_at desc", :limit => $number_articles_on_homepage )
    newest_howto_articles = HowTo.find(:all, :conditions => "state='published'", :order => "published_at desc", :limit => $number_articles_on_homepage )
    newest_articles = newest_straight_articles + newest_howto_articles
    newest_articles = newest_articles.sort_by(&:published_at)
    newest_articles.reverse!
    return newest_articles[0..$number_articles_on_homepage-1]
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
		help.shorten_string(title, MAX_LENGTH_SLUG, "").parameterize
	end
end
