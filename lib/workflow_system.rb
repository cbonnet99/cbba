module WorkflowSystem
  def self.included(base)
		base.send :include, Authorization::AasmRoles::StatefulRolesInstanceMethods
		base.send :include, AASM

    base.send :include, WorkflowInstanceMethods
    base.send :extend, WorkflowClassMethods
    base.send :aasm_column, :state
    base.send :aasm_initial_state, :initial => :draft
    base.send :aasm_state, :draft
    base.send :aasm_state, :published, :enter => :email_reviewers

    base.send :aasm_event, :publish do
      transitions :from => :draft, :to => :published
    end

    base.send :aasm_event, :remove do
      transitions :from => :published, :to => :draft
    end

    base.send :aasm_event, :reject do
      transitions :from => :published, :to => :draft
    end

  end
  module WorkflowClassMethods
    def count_reviewable(conditions=nil)
      self.count(:all, :conditions => "approved_by_id is null and state='published'")
    end
    def reviewable(conditions=nil)
      self.find(:all, :conditions => "approved_by_id is null and state='published'")
    end
  end
  module WorkflowInstanceMethods
    def workflow_css_class
      "workflow-#{self.state}"
    end

  	def email_reviewers
      self.published_at = Time.now.utc
      User.reviewers.each do |r|
        UserMailer.deliver_stuff_to_review(self, r)
      end
    end
    def reviewable?
      state == "published" && approved_at.nil?
    end

  end
end