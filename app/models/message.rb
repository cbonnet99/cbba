class Message < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :subject, :preferred_contact, :body
  validates_length_of :preferred_contact, :maximum => 255
  validates_length_of :subject, :maximum => 255
  validates_length_of :body, :maximum => 100000
end
