require File.dirname(__FILE__) + '/../../lib/helpers'

class Article < ActiveRecord::Base
  include Slugalizer
	include SubcategoriesSystem
	include Authorization::AasmRoles::StatefulRolesInstanceMethods
	include AASM
	aasm_column :state
	aasm_initial_state :initial => :draft
	aasm_state :draft
	aasm_state :published, :enter => :email_reviewers

	aasm_event :publish do
		transitions :from => :draft, :to => :published
	end

	aasm_event :remove do
		transitions :from => :published, :to => :draft
	end

	aasm_event :reject do
		transitions :from => :published, :to => :draft
	end

  acts_as_taggable
	
  belongs_to :author, :class_name => "User"
	has_many :articles_subcategories
	has_many :subcategories, :through => :articles_subcategories
	has_many :articles_categories
	has_many :categories, :through => :articles_categories
	belongs_to :approved_by, :class_name => "User"
	belongs_to :rejected_by, :class_name => "User"
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 80

	after_create :create_slug, :create_intro
#	after_update :create_slug, :create_intro

  MAX_LENGTH_INTRODUCTION = 100
	MAX_LENGTH_SLUG = 20

	def reviewable?
		state == "published" && approved_at.nil?
	end

	def email_reviewers
		User.reviewers.each do |r|
			UserMailer.deliver_article_to_review(self, r)
		end
	end

	def self.count_reviewable
		Article.count_by_sql("select count(*) from articles where approved_by_id is null and state='published'")
	end

	def self.reviewable
		Article.find_by_sql("select a.* from articles a where approved_by_id is null and state='published'")
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
