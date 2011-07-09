class VirtualTab < Struct.new( :slug, :title, :partial, :nav)
  def virtual?
    true
  end
  def content
    title
  end
  def needs_edit?
    false
  end
end
class Tab < ActiveRecord::Base

  ARTICLES = "articles"
  OFFERS = "offers"
  MAX_PER_USER = 3
  DEFAULT_CONTENT1_WITH = "Write about what people can expect from you and your service... (Just delete this text to remove it from your profile)"
  DEFAULT_CONTENT2_BENEFITS = "<ul><li>List a benefit here (or delete this text)</li> <li>List a benefit here (or delete this text)</li> <li>List a benefit here (or delete this text)</li> </ul>"
  DEFAULT_CONTENT3_TRAINING = "<ul><li>List your training here (or delete this text)</li> <li>List your training here&nbsp;(or delete this text)</li> <li>List your training here&nbsp;(or delete this text)</li> </ul>"
  DEFAULT_CONTENT4_ABOUT = "Give a summary here of your service&nbsp;(Just delete this text to remove it from your profile)"
  
  after_create :create_slug, :create_link_to_subcategories, :set_contents
  after_update :update_subcategories
  before_update :update_content
  before_save :change_slug

  acts_as_list :scope => :user_id

  belongs_to :user
  belongs_to :subcategory

  validates_presence_of :title, :message => "^Please select a modality"
  validates_uniqueness_of :title, :scope => :user_id, :message => "^You already have this modality"
  validates_length_of :title, :maximum => 31
  
  attr_accessor :old_title, :content1_with, :content2_benefits, :content3_training, :content4_about
  
  def needs_edit?
    self.content =~ /delete this text/ || self.content1_with =~ /delete this text/ || self.content2_benefits =~ /delete this text/ || self.content3_training =~ /delete this text/ || self.content4_about =~ /delete this text/
  end
  
  def self.content_for_title(title, c)
    strings = c.split("<h3>#{title}</h3>")
    if strings.length > 1
      return strings[1].split("<h3>")[0]
    else
      return ""
    end
  end

  def set_contents
    if self.content1_with.blank? && self.content2_benefits.blank? && self.content3_training.blank? && self.content4_about.blank?
      unless content.nil?
        titles = self.content.split("<h3>").select{|str| str.match(%r{</h3>})}.map{|str| str.split("</h3>")[0]}
        if titles.include?(title1_with)
          self.content1_with = Tab.content_for_title(title1_with, self.content)
          titles.delete(title1_with)
        else
          self.content1_with = ""
        end
        if titles.include?(title2_benefits)
          self.content2_benefits = Tab.content_for_title(title2_benefits, self.content)
          titles.delete(title2_benefits)
        else
          self.content2_benefits = ""
        end
        if titles.include?(title3_training)
          self.content3_training = Tab.content_for_title(title3_training, self.content)
          titles.delete(title3_training)
        else
          self.content3_training = ""
        end
        if titles.include?(title4_about)
          self.content4_about = Tab.content_for_title(title4_about, self.content)
          titles.delete(title4_about)
        else
          self.content4_about = ""
        end
        unless titles.blank?
          titles.each do |t|
            self.content1_with << "<h3>#{t}</h3>#{Tab.content_for_title(t, self.content)}"
          end
        end
      end
    end
  end
  
  def update_content
    if self.content.nil? || (!content1_with.blank? || !content2_benefits.blank? || !content3_training.blank? || !content4_about.blank?)
      self.content = "<h3>#{title1_with}</h3>#{help.remove_html_titles(content1_with)}<h3>#{title2_benefits}</h3>#{help.remove_html_titles(content2_benefits)}<h3>#{title3_training}</h3>#{help.remove_html_titles(content3_training)}<h3>#{title4_about}</h3>#{help.remove_html_titles(content4_about)}"
    end
  end
  
  def subcategory_with_fallback
    if subcategory.nil?
      self.title
    else
      subcategory.name
    end
  end
  
  def title1_with
    "#{subcategory_with_fallback} with #{user.try(:name)}"
  end
  
  def title2_benefits
    "Benefits of #{subcategory_with_fallback}"
  end
  
  def title3_training
    "Training"
  end
  
  def title4_about
    "About #{user.try(:name)}"
  end
  
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
