class AddExpertApplicationIdToPayment < ActiveRecord::Migration
  def self.up
    add_column :payments, :expert_application_id, :integer
  end

  def self.down
    remove_column :payments, :expert_application_id
  end
end
