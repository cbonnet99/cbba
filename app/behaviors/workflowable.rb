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
    base.send :aasm_state, :published, :enter => :on_publish_enter
    
    base.send :aasm_event, :publish do
      transitions :from => :draft, :to => :published, :guard => Proc.new {|item| item.paid_items_left?}
    end

    base.send :aasm_event, :remove do
      transitions :from => :published, :to => :draft, :on_transition => :remove_published_information_and_decrement_count
    end

    base.send :aasm_event, :reject do
      transitions :from => :published, :to => :draft, :on_transition => :decrement_published_count
    end

    base.send :after_destroy, :decrement_published_count

    base.send :named_scope, :latest, :conditions => ["published_at > ?", 1.month.ago]

  end
  module WorkflowClassMethods
    
    def last_published_at
      self.first(:order=>"published_at DESC", :conditions=>"published_at IS NOT NULL").try(:published_at)
    end
        
    def currently_selected_and_last_10_published(newsletter)
      res = Set.new
      newsletter.send(self.to_s.tableize.to_sym).each do |i|
        res << i
      end
      self.find(:all, :conditions => "state = 'published' AND published_at is not null AND rejected_at is null",  :order => "published_at desc", :limit => 10).each do |i|
        res << i
      end
      res
    end
    
    def published_in_last_2_months(start=Time.now)
      self.find(:all, :conditions => ["state = 'published' AND published_at BETWEEN ? AND ?  AND rejected_at is null", start.advance(:months => -2), Time.now])
    end
    
    def count_reviewable
      self.count(:all, :conditions => "approved_by_id is null and state='published'")
    end
    def reviewable
      self.find(:all, :conditions => "approved_by_id is null and state='published'")
    end
    def approved
      self.find(:all, :conditions => "status='approved' AND rejected_at is null")
    end
    def rejected
      self.find(:all, :conditions => "status='rejected'")
    end
    def pending
      self.find(:all, :conditions => "status='pending'")
    end
  end
  module WorkflowInstanceMethods
    
    def on_publish_enter
      email_reviewers_and_increment_count
    end
        
    def label(url="")
      if url.blank?
        res = "#{self.title}<br/>"
      else
        res = "<a href=\"#{url}\">#{self.title}</a><br/>"
      end
      sub = ""
      sub << "#{self.subcategory.name} - " if self.respond_to?(:subcategory) && !self.subcategory.nil?
      sub << "offered by #{self.author.name}" if self.respond_to?(:author) && !self.author.nil?
      res << sub[0..0].upcase
      res << sub[1..sub.length]
    end

    def paid_items_left?
      !self.author.respond_to?("paid_#{self.class.to_s.tableize}") || (self.author.respond_to?("paid_#{self.class.to_s.tableize}") && self.class.to_s != "UserProfile" && self.author.send("#{self.class.to_s.tableize}".to_sym).published.size < self.author.send("paid_#{self.class.to_s.tableize}"))
    end

    def path_method
      self.class.to_s.tableize.singularize+"_url"
    end

    def workflow_css_class
      "workflow-#{self.state}"
    end

    def decrement_published_count
      sym = "published_#{self.class.to_s.tableize}_count".to_sym
      if self.respond_to?(:author) && self.author.respond_to?(sym)
        self.author.update_attribute(sym, self.author.send(sym)-1)
      end      
      if self.respond_to?(:subcategory) && self.subcategory.respond_to?(sym)
        self.subcategory.update_attribute(sym, self.subcategory.send(sym)-1)
      end
    end

    def remove_published_information_and_decrement_count
      self.update_attributes(:approved_at => nil, :approved_by => nil, :published_at => nil)
      sym = "published_#{self.class.to_s.tableize}_count".to_sym
      if self.respond_to?(:author) && self.author.respond_to?(sym)
        self.author.update_attribute(sym, self.author.send(sym)-1)
      end
      if self.respond_to?(:subcategory) && self.subcategory.respond_to?(sym)
        self.subcategory.update_attribute(sym, self.subcategory.send(sym)-1)
      end
    end

  	def email_reviewers_and_increment_count
      self.published_at = Time.now.utc
      User.reviewers.each do |r|
        UserMailer.deliver_stuff_to_review(self, r)
      end
      sym = "published_#{self.class.to_s.tableize}_count".to_sym
      if self.respond_to?(:author) && self.author.respond_to?(sym)
        self.author.update_attribute(sym, self.author.send(sym)+1)
      end
      if self.respond_to?(:subcategory) && self.subcategory.respond_to?(sym)
        self.subcategory.update_attribute(sym, self.subcategory.send(sym)+1)
      end
    end

    def reviewable?
      state == "published" && approved_at.nil?
    end
    
    def approved?
      state == "published" && !approved_at.nil? && (rejected_at.nil? || approved_at > rejected_at)
    end
  end
end