class Question < ActiveRecord::Base
  belongs_to :contact
  include Workflowable
  include BlogSubcategoriesSystem

	has_many :blog_subcategories_questions
	has_many :blog_subcategories, :through => :blog_subcategories_questions
	has_many :blog_categories_questions
	has_many :blog_categories, :through => :blog_categories_questions
	belongs_to :contact
	belongs_to :country
  
  attr_accessor :email, :receive_newsletter
  
  before_create :check_email
  
  def check_email
    self.contact = Contact.find_by_email(self.email)
    if self.contact.nil?
      self.contact = Contact.create(:email => self.email, :receive_newsletter => self.receive_newsletter, :country_id => self.country_id)
    else
      self.country_id = self.contact.country_id
    end
  end
end
