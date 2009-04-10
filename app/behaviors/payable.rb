module Payable
  def self.included(base)
		base.send :include, Authorization::AasmRoles::StatefulRolesInstanceMethods
		base.send :include, AASM

    base.send :include, PayableInstanceMethods
    base.send :extend, PayableClassMethods
    base.send :belongs_to, :user
    
    base.send :before_create, :compute_gst
    
    
    base.send :aasm_column, :status
    base.send :aasm_initial_state, :initial => :pending
    base.send :aasm_state, :pending
    base.send :aasm_state, :completed, :enter => :finalize_complete

    base.send :aasm_event, :complete do
      transitions :from => :pending, :to => :completed
    end
  end
  module PayableClassMethods
    def pending
      self.find(:all, :conditions => "status ='pending'")
    end
    def renewals
      self.find(:all, :conditions => "payment_type = 'renewal'")
    end
  end
  module PayableInstanceMethods

    def finalize_complete
      if payment_type == "new" || payment_type == "renewal"
        user.member_since = Time.now if user.member_since.nil?
        if user.member_until.nil?
          user.member_until = 1.year.from_now
        else
          user.member_until += 1.year
        end
        #in case this is a free listing user upgrading...
        if user.free_listing?
          user.free_listing = false
          user.add_role("full_member")
        end
      end
      if payment_type == "resident_expert" || payment_type == "resident_expert_renewal"
        user.resident_since = Time.now if user.resident_since.nil?
        if user.resident_until.nil?
          user.resident_until = 1.year.from_now
        else
          user.resident_until += 1.year
        end
        if !user.resident_expert?
          user.free_listing = false
          user.add_role("resident_expert")
          subcat = expert_application.subcategory
          if !subcat.resident_expert.nil?
            logger.error("User: #{user.full_name} has paid to become resident expert on #{subcat.name}, but there is already an expert: #{subcat.resident_expert.full_name}")
          else
            subcat.update_attribute(:resident_expert_id, user.id)
          end
        end
      end
      user.save!
      user.activate! unless user.active?
    end

    def total
      self.amount+self.gst
    end

    def compute_gst
      my_divmod = (Payment::GST*self.amount).divmod(10000)
      diviseur = my_divmod[0]
      reste = my_divmod[1]
      diviseur += 1 if reste > 5000
      self.gst = diviseur
    end

    def completed?
      !self.status.nil? && self.status == "completed"
    end

    def pending?
      !self.status.nil? && self.status == "pending"
    end

  end
end