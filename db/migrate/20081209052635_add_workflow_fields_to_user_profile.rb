class AddWorkflowFieldsToUserProfile < ActiveRecord::Migration
  def self.up
		add_column :user_profiles, :published_at, :timestamp
		add_column :user_profiles, :reason_reject, :text
		add_column :user_profiles, :rejected_at, :timestamp
		add_column :user_profiles, :rejected_by_id, :integer
  end

  def self.down
		remove_column :user_profiles, :published_at
		remove_column :user_profiles, :reason_reject
		remove_column :user_profiles, :rejected_at
		remove_column :user_profiles, :rejected_by_id
  end
end
