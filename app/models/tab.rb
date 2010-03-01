class VirtualTab < Struct.new( :slug, :title, :partial, :nav)
  def virtual?
    true
  end
  def content
    title
  end
end
class Tab < ActiveRecord::Base

  ARTICLES = "articles"
  OFFERS = "offers"
  MAX_PER_USER = 3
  
  after_create :create_slug, :create_link_to_subcategories
  after_update :update_subcategories
  before_save :change_slug

  acts_as_list :scope => :user_id

  belongs_to :user

  validates_presence_of :title, :message => "^Please select a modality"
  validates_uniqueness_of :title, :scope => :user_id, :message => "^You already have this modality"
  validates_length_of :title, :maximum => 30
  
  attr_accessor :old_title
  
  def change_slug
    self.slug = self.title.parameterize
  end
  
  def create_link_to_subcategories
    new_subcategory = Subcategory.find_by_name(title)
    if !new_subcategory.nil? && !user.subcategories.include?(new_subcategory)
      user.subcategories << new_subcategory
    end
  end
  
  def update_subcategories
    if !old_title.nil? && old_title != title
      old_subcategory = Subcategory.find_by_name(old_title)
      new_subcategory = Subcategory.find_by_name(title)
      if !new_subcategory.nil? && !old_subcategory.nil? && user.subcategories.include?(old_subcategory)
        user.subcategories.delete(old_subcategory)
        user.subcategories << new_subcategory
      end
    end
  end
  
  def virtual?
    false
  end

  def validate
    if !title.nil? && (title.downcase == ARTICLES || title.downcase == OFFERS)
      errors.add(:title, "^#{title} is a reserved title")
    end
  end

  def to_param
     slug
  end

	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		res = title.parameterize
	end

end
