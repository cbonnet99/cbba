class ExpertApplication < ActiveRecord::Base
  include AASM

  after_create :email_admins

  belongs_to :user
  belongs_to :subcategory
  belongs_to :approved_by, :class_name => "User"
  belongs_to :rejected_by, :class_name => "User"
  belongs_to :payment

  validates_presence_of :subcategory, :expert_presentation

  aasm_column :status
  aasm_initial_state :initial => :pending
  aasm_state :pending
  aasm_state :approved
  aasm_state :rejected
  aasm_state :timed_out

  named_scope :approved_without_payment, :include => :payment, :conditions => "expert_applications.status='approved' and (payment_id is null or payments.status='pending')"
  named_scope :pending, :conditions => "status='pending'"

  aasm_event :approve do
      transitions :from => :pending, :to => :approved, :on_transition => :email_approve_expert
  end

  aasm_event :reject do
      transitions :from => :pending, :to => :rejected
  end

  aasm_event :time_out do
      transitions :from => :approved, :to => :pending, :on_transition => :email_time_out_expert
  end

  def expertise
    subcategory.name unless subcategory.nil?
  end

  def email_admins
      User.resident_expert_admins.each do |u|
        UserMailer.deliver_notifiy_admin_new_expert_application(self, u)
      end
  end

  def email_approve_expert
    new_payment = user.payments.create!(Payment::TYPES[:resident_expert])
    self.update_attribute(:payment_id, new_payment.id)
    UserMailer.deliver_approve_expert(user, self)
  end

  def email_time_out_expert
    UserMailer.deliver_expert_application_time_out(user, self)
  end

end
