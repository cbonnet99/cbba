class AddWorkflowFieldsToExpertApplication < ActiveRecord::Migration
  def self.up
		add_column :expert_applications, :approved_at, :timestamp
		add_column :expert_applications, :approved_by_id, :integer
		add_column :expert_applications, :reason_reject, :text
		add_column :expert_applications, :rejected_at, :timestamp
		add_column :expert_applications, :rejected_by_id, :integer
  end

  def self.down
		remove_column :expert_applications, :approved_at
		remove_column :expert_applications, :approved_by_id
		remove_column :expert_applications, :reason_reject
		remove_column :expert_applications, :rejected_at
		remove_column :expert_applications, :rejected_by_id
  end
end
