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
    base.send :aasm_state, :published, :enter => :email_reviewers_and_increment_count

    base.send :aasm_event, :publish do
      transitions :from => :draft, :to => :published, :guard => Proc.new {|item| item.exceeds_max_published?}
    end

    base.send :aasm_event, :remove do
      transitions :from => :published, :to => :draft, :on_transition => :remove_published_information_and_decrement_count
    end

    base.send :aasm_event, :reject do
      transitions :from => :published, :to => :draft
    end

    base.send :after_destroy, :decrement_count

  end
  module WorkflowClassMethods
    def count_reviewable
      self.count(:all, :conditions => "approved_by_id is null and state='published'")
    end
    def reviewable
      self.find(:all, :conditions => "approved_by_id is null and state='published'")
    end
    def approved
      self.find(:all, :conditions => "status='approved'")
    end
    def rejected
      self.find(:all, :conditions => "status='rejected'")
    end
    def pending
      self.find(:all, :conditions => "status='pending'")
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

    def exceeds_max_published?
      !self.author.respond_to?("max_published_#{self.class.to_s.tableize}") || (self.author.respond_to?("max_published_#{self.class.to_s.tableize}") && self.class.to_s != "UserProfile" && self.author.send("#{self.class.to_s.tableize}".to_sym).published.size < self.author.send("max_published_#{self.class.to_s.tableize}"))
    end

    def path_method
      self.class.to_s.tableize.singularize+"_path"
    end

    def workflow_css_class
      "workflow-#{self.state}"
    end

    def decrement_count
      unless self.class.to_s == "UserProfile"
        sym = "published_#{self.class.to_s.tableize}_count".to_sym
        self.author.update_attribute(sym, self.author.send(sym)-1)
      end      
    end

    def remove_published_information_and_decrement_count
      self.update_attributes(:approved_at => nil, :approved_by => nil, :published_at => nil)
      unless self.class.to_s == "UserProfile"
        sym = "published_#{self.class.to_s.tableize}_count".to_sym
        self.author.update_attribute(sym, self.author.send(sym)-1)
      end
    end

  	def email_reviewers_and_increment_count
      self.published_at = Time.now.utc
      User.reviewers.each do |r|
        UserMailer.deliver_stuff_to_review(self, r)
      end
      unless self.class.to_s == "UserProfile"
        sym = "published_#{self.class.to_s.tableize}_count".to_sym
        self.author.update_attribute(sym, self.author.send(sym)+1)
      end
    end

    def reviewable?
      state == "published" && approved_at.nil?
    end

  end
end