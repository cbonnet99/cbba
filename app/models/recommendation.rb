class Recommendation < ActiveRecord::Base
	include AASM
  aasm_column :status
  aasm_initial_state :initial => :pending
  aasm_state :pending, :enter => :email_recommended_user
  aasm_state :accepted
  aasm_state :rejected

  aasm_event :accept do
    transitions :from => :pending, :to => :accepted
  end
	
  aasm_event :reject do
    transitions :from => :pending, :to => :rejected
  end
	
  belongs_to :user
  belongs_to :recommended_user, :class_name => "User" 
end
