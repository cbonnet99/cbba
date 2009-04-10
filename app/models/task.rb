class Task < ActiveRecord::Base
  
  XERO_INVOICES = "xero_invoices"
  
  def self.last_run(name)
    task = Task.find_by_name(name)
    task.nil? ? nil : task.last_run
  end
  
  def self.set_last_run(name, time)
    task = Task.find_or_create_by_name(name)
    task.update_attribute(:last_run, time)
  end
  
end
