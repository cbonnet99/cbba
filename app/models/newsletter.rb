class Newsletter < ActiveRecord::Base
  include AASM
  belongs_to :author, :class_name => "User"
  belongs_to :publisher, :class_name => "User"
  aasm_column :state
  aasm_initial_state :draft
  aasm_state :draft
  aasm_state :published

  aasm_event :publish do
    transitions :from => :draft, :to => :published, :on_transition => :mark_publish_info 
  end
  aasm_event :retract do
    transitions :to => :draft, :from => :published, :on_transition => :mark_unpublish_info 
  end

  attr_accessor :current_publisher
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 255

  def mark_unpublish_info
    self.published_at = nil
    self.publisher = nil
    self.save!
  end
  
  def mark_publish_info
    self.published_at = Time.now
    self.publisher = self.current_publisher
    self.save!
  end
  
end
