class ExpertApplication < ActiveRecord::Base
  include AASM

  after_create :email_admins

  belongs_to :user
  belongs_to :subcategory
  belongs_to :approved_by, :class_name => "User"
  belongs_to :rejected_by, :class_name => "User"
  has_one :payment

  validates_presence_of :subcategory, :expert_presentation

  aasm_column :status
  aasm_initial_state :initial => :pending
  aasm_state :pending
  aasm_state :approved
  aasm_state :rejected
  aasm_state :timed_out

  named_scope :pending, :conditions => "status='pending'"
  named_scope :approved, :conditions => "status='approved'"
  named_scope :rejected, :conditions => "status='rejected'"

  aasm_event :approve do
      transitions :from => :pending, :to => :approved, :on_transition => :email_approve_expert
  end

  aasm_event :reject do
      transitions :from => :pending, :to => :rejected
  end

  aasm_event :time_out do
      transitions :from => :confirmed, :to => :pending, :on_transition => :email_time_out_expert
  end

  def email_admins
      User.resident_expert_admins.each do |u|
        UserMailer.deliver_notifiy_admin_new_expert_application(self, u)
      end
  end

  def email_approve_expert
    new_payment = user.payments.create!(Payment::TYPES[:resident_expert])
    self.update_attribute(:payment, new_payment)
    UserMailer.deliver_approve_expert(user, self)
  end

  def email_time_out_expert
    
  end

end
