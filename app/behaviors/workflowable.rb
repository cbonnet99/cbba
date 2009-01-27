module Workflowable
  def self.included(base)
		base.send :include, Authorization::AasmRoles::StatefulRolesInstanceMethods
		base.send :include, AASM

    base.send :include, WorkflowInstanceMethods
    base.send :extend, WorkflowClassMethods
    base.send :belongs_to, :approved_by, :class_name => "User"
    base.send :belongs_to, :rejected_by, :class_name => "User"
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
    def count_reviewable
      self.count(:all, :conditions => "approved_by_id is null and state='published'")
    end
    def reviewable
      self.find(:all, :conditions => "approved_by_id is null and state='published'")
    end
  end
  module WorkflowInstanceMethods

    #    def path_to_item(item=self)
    #      if respond_to?(:custom_path)
    #        custom_path(item)
    #      else
    #        method = self.method((self.class.to_s.tableize.singularize+"_path").to_sym)
    #        method.call(item)
    #      end
    #    end

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