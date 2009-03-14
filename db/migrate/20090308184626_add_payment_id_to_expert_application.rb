class AddPaymentIdToExpertApplication < ActiveRecord::Migration
  def self.up
    add_column :expert_applications, :payment_id, :integer
    remove_column :payments, :expert_application_id
  end

  def self.down
    remove_column :expert_applications, :payment_id
    add_column :payments, :expert_application_id, :integer
  end
end
