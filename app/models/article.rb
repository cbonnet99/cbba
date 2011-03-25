require File.dirname(__FILE__) + '/../../lib/helpers'

class Article < ActiveRecord::Base
	include SubcategoriesSystem
  include BlogSubcategoriesSystem
  include MultiAfterFindSystem
  include Workflowable
  include Sluggable
	
  belongs_to :author, :class_name => "User", :counter_cache => true
	has_many :articles_subcategories
	has_many :subcategories, :through => :articles_subcategories
	has_many :articles_categories
	has_many :categories, :through => :articles_categories
	has_many :articles_blog_subcategories
	has_many :blog_subcategories, :through => :articles_blog_subcategories
	has_many :articles_blog_categories
	has_many :blog_categories, :through => :articles_blog_categories
  has_many :articles_newsletters
  has_many :newsletters, :through => :articles_newsletters 
  belongs_to :country

  validates_presence_of :title, :lead, :author
  validates_length_of :title, :maximum => 255
  validates_length_of :lead, :maximum => 500
  validates_length_of :body, :maximum => 100000
  validates_uniqueness_of :title, :scope => "author_id", :message => "is already used for another of your articles" 

	before_create :remove_html_from_lead
	before_update :remove_html_from_lead
	after_save :update_user_about

  MAX_LENGTH_SLUG = 20
  POINTS_FOR_RECENT_ARTICLE = 10
  POINTS_FOR_OLDER_ARTICLE = 5
  SHORT_LEAD_MAX_SIZE = 200
  MAX_ARTICLES_ON_INDEX = 6
  NUMBER_ON_HOMEPAGE = 10
  
  def self.homepage_featured(country)
    Article.find(:all, :conditions => ["homepage_featured is true and country_id=?", country.id])
  end
  
  def self.rotate_featured(country)
    article_to_feature = Article.find(:first, :include => "author", :conditions => ["articles.last_homepage_featured_at is NULL and users.paid_photo is true and articles.state='published' and articles.country_id=?", country.id])
    if article_to_feature.nil?
      article_to_feature = Article.find(:first, :include => "author", :conditions => ["users.paid_photo is true and articles.state='published' and articles.country_id=?", country.id], :order => "articles.last_homepage_featured_at")
    end
    unless article_to_feature.nil?
      Article.homepage_featured(country).each {|a| a.update_attribute(:homepage_featured, false)}
      article_to_feature.homepage_featured = true
      article_to_feature.last_homepage_featured_at = Time.now
      article_to_feature.save!
      UserMailer.deliver_featured_homepage_article(article_to_feature)
    end
  end
  
  def to_s
    "#{self.id}: #{self.title}"
  end
  
  def self.popular
    self.find(:all, :order => "monthly_view_counts desc", :limit => 10)
  end
  
  def self.first_homepage_featured(country)
    Article.homepage_featured(country).first
  end
  
  def last_articles_for_main_subcategory
    if main_subcategory.nil?
      Rails.logger.error("Article ID #{self.id} has a main subcategory that doesn't exist anymore")
      return []
    else
      return main_subcategory.last_articles(6)
    end
  end
  
	def self.count_published_articles
	  Article.find_all_by_state("published").size
  end  
  
  def about_section
    if self.about.blank?
      ""
    else
      "<h4>About the author</h4>#{self.about}<br/>"
    end
  end
  
  def update_user_about
    unless author.nil?
      author.update_attribute(:about, self.about)
    end
  end
  
  def self.recent_articles(country)
    if country.nil?
      Article.find_all_by_state("published", :limit => MAX_ARTICLES_ON_INDEX, :order => "published_at desc" )
    else
      country.articles.find_all_by_state("published", :limit => MAX_ARTICLES_ON_INDEX, :order => "published_at desc" )      
    end
  end

  def summary
    lead
  end
  
  def short_lead
    if self.lead.size < SHORT_LEAD_MAX_SIZE
      self.lead
    else
      "#{self.lead[0..SHORT_LEAD_MAX_SIZE-1]}..."
    end
  end
  
  def on_publish_enter
    send_congrats_on_first
    email_reviewers_and_increment_count
    compute_points
  end

  def compute_points
    unless subcategory.nil?
      su = self.author.subcategories_users.find_by_subcategory_id(subcategory.id)
      unless su.nil?
        su.update_attribute(:points, su.points+POINTS_FOR_RECENT_ARTICLE)
      end
    end
  end
  
  def subcategory
    unless self.subcategory1_id.nil?
      Subcategory.find(self.subcategory1_id)
    end
  end

  def send_congrats_on_first
    if self.author.articles.published.size == 0
      UserMailer.deliver_congrats_first_article(self.author)
    end
  end
    
  def self.search(subcategory, category, district, region)
    subcategories = category.subcategories unless category.nil?
    subcategories = [subcategory] unless subcategory.nil?
    if !subcategory.nil? && !region.nil?
      res = Article.find_by_sql(["select a.* from articles a, articles_subcategories asub, districts d, users u where d.region_id = ? and d.id = u.district_id and u.id = a.author_id and a.state = 'published' and a.id = asub.article_id and asub.subcategory_id in (?) order by a.published_at desc", region.id, subcategories])
    end
    if !subcategory.nil? && !district.nil?
      res = Article.find_by_sql(["select a.* from articles a, articles_subcategories asub, users u where u.district_id = ? and u.id = a.author_id and a.state = 'published' and a.id = asub.article_id and asub.subcategory_id in (?) order by a.published_at desc", district.id, subcategories])
    end
    res
  end
  
  def remove_html_from_lead
    self.lead = self.lead.gsub(/<\/?[^>]*>/,"")
  end

  def validate
    if subcategory1_id.blank?
      errors.add(:subcategory1_id, "^You must select at least one category")
    end
  end

  def self.count_published(country)
    Article.count(:all, :conditions => ["state = 'published' and country_id = ?", country.id])
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

	def self.find_all_by_subcategories_and_country_code(country_code, *subcategories)
	  if country_code.blank?
	    return self.find_all_by_subcategories(*subcategories)
    else
		  Article.find_by_sql(["select a.* from articles a, articles_subcategories asub, countries c where c.country_code = ? and c.id = a.country_id and a.state = 'published' and a.id = asub.article_id and asub.subcategory_id in (?)", country_code, subcategories])
	  end
	end

  def self.all_newest_articles
    newest_straight_articles = Article.find(:all, :conditions => "state='published'", :order => "published_at desc", :limit => Article::NUMBER_ON_HOMEPAGE)
    newest_howto_articles = HowTo.find(:all, :conditions => "state='published'", :order => "published_at desc", :limit => Article::NUMBER_ON_HOMEPAGE)
    newest_articles = newest_straight_articles + newest_howto_articles
    newest_articles = newest_articles.sort_by(&:published_at)
    newest_articles.reverse!
    return newest_articles[0..Article::NUMBER_ON_HOMEPAGE-1]
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
end
