class VirtualTab < Struct.new( :slug, :title, :partial, :nav)
  def virtual?
    true
  end
end
class Tab < ActiveRecord::Base

  ARTICLES = "articles"
  OFFERS = "offers"
  MAX_PER_USER = 3
  
  after_create :create_slug

  acts_as_list :scope => :user_id

  belongs_to :user

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :user_id
  validates_length_of :title, :maximum => 30

  def virtual?
    false
  end

  def validate
    if title.downcase == ARTICLES || title.downcase == OFFERS
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
