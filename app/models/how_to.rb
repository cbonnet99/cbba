class HowTo < ActiveRecord::Base
	include SubcategoriesSystem
  include WorkflowSystem

  has_many :how_to_steps, :order => "position", :dependent => :destroy
  belongs_to :author, :class_name => "User"
	has_many :how_tos_subcategories
	has_many :subcategories, :through => :how_tos_subcategories
	has_many :how_tos_categories
	has_many :categories, :through => :how_tos_categories

	MAX_LENGTH_SLUG = 50
  
  validates_presence_of :title, :summary
  validates_associated :how_to_steps

	after_create :create_slug
  after_update :save_steps

  def path_method
    "how_to_path"
  end

	def self.id_from_url(url)
		unless url.nil?
			url.split("-").first.to_i
		end
	end
  
	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		help.shorten_string(title, MAX_LENGTH_SLUG, "").parameterize
	end

	def slug
		#just in case the slug is nil (for fixtures, for instance)
		slug ||= computed_slug
	end

  def to_param
     "#{id}-#{slug}"
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
