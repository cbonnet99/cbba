class Question < ActiveRecord::Base
  include Workflowable
  
  has_many :answers, :dependent => :delete_all
	belongs_to :blog_category
  belongs_to :author, :class_name => "Contact"
	belongs_to :country

  validates_length_of :body, :maximum => 500
  
  attr_accessor :email, :receive_newsletter
  
  before_create :check_email

  def title
    if self.body.size > 200
      "#{self.body[0..200]}..."
    else
      self.body
    end
  end

  def self.find_question(contact, id)
    question = Question.find(:first, :conditions => ["state = 'published' and id = ?", id])
    if question.nil? && !contact.nil? && contact.is_a?(Contact)
      question = contact.questions.find(params[:id])
    end
    return question
  end
  
  def check_email
    self.author = Contact.find_by_email(self.email)
    if self.author.nil?
      self.author = Contact.create(:email => self.email, :receive_newsletter => self.receive_newsletter, :country_id => self.country_id)
    else
      self.country_id = self.author.country_id
    end
  end
end
