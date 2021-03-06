class HowTo < ActiveRecord::Base
	include SubcategoriesSystem
  include MultiAfterFindSystem
  include Workflowable
  include Sluggable

  has_many :how_to_steps, :order => "position", :dependent => :destroy
  belongs_to :author, :class_name => "User", :counter_cache => true
	has_many :how_tos_subcategories
	has_many :subcategories, :through => :how_tos_subcategories
	has_many :how_tos_categories
	has_many :categories, :through => :how_tos_categories
  belongs_to :country
  
	MAX_LENGTH_SLUG = 50
  
  validates_presence_of :title, :summary
  validates_length_of :title, :maximum => 255
  validates_length_of :summary, :maximum => 500
  validates_associated :how_to_steps
  validates_uniqueness_of :title, :scope => "author_id", :message => "is already used for another of your 'how to' articles" 

	before_update :remove_html_from_summary
	before_create :remove_html_from_summary
  after_update :save_steps

  def lead
    summary
  end

  def remove_html_from_summary
    self.summary = self.summary.gsub(/<\/?[^>]*>/,"")
  end

  def self.count_published
    HowTo.count(:all, :conditions => "state = 'published'")
  end

	def self.find_all_by_subcategories(*subcategories)
		HowTo.find_by_sql(["select ht.* from how_tos ht, how_tos_subcategories htsub where ht.state = 'published' and ht.id = htsub.how_to_id and htsub.subcategory_id in (?)", subcategories])
	end

  def self.find_all_by_subcategories_and_country_code(country_code, *subcategories)
    if country_code.blank?
      self.find_all_by_subcategories(*subcategories)
    else
  		HowTo.find_by_sql(["select ht.* from how_tos ht, how_tos_subcategories htsub, countries c where c.country_code = ? and c.id = ht.country_id and ht.state = 'published' and ht.id = htsub.how_to_id and htsub.subcategory_id in (?)", country_code, subcategories])
    end
  end

  def validate
    if subcategory1_id.blank?
      errors.add(:subcategory1_id, "^You must select at least one category")
    end
  end
    
  def new_step_attributes=(step_attributes)
    step_attributes.each do |attributes|
      how_to_steps.build(attributes)
    end
  end

  def existing_step_attributes=(step_attributes)
    how_to_steps.reject(&:new_record?).each do |step|
      attributes = step_attributes[step.id.to_s]
      if attributes
        step.attributes = attributes
      else
        how_to_steps.delete(step)
      end
    end
  end

  def save_steps
    how_to_steps.each do |step|
      step.save(false)
    end
  end


end
