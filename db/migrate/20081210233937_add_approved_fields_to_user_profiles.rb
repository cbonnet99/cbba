class AddApprovedFieldsToUserProfiles < ActiveRecord::Migration
  def self.up
		add_column :user_profiles, :comment_approve, :text
		add_column :user_profiles, :approved_at, :timestamp
		add_column :user_profiles, :approved_by_id, :integer
  end

  def self.down
		remove_column :user_profiles, :comment_approve
		remove_column :user_profiles, :approved_at
		remove_column :user_profiles, :approved_by_id
  end
end
