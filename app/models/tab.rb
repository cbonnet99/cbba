class Tab < ActiveRecord::Base

  include Slugalizer

  after_create :create_slug

  acts_as_list :scope => :user_id

  belongs_to :user

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :user_id

  def to_param
     slug
  end

	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		res = Slugalizer.slugalize(title)
	end

end
