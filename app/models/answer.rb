class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  
  validates_presence_of :body
  validates_length_of :body, :maximum => 500
end
