class AddApprovedToArticles < ActiveRecord::Migration
  def self.up
		add_column :articles, :comment_approve, :text
		add_column :articles, :approved_at, :timestamp
		add_column :articles, :approved_by_id, :integer
  end

  def self.down
		remove_column :articles, :comment_approve
		remove_column :articles, :approved_at
		remove_column :articles, :approved_by_id
  end
end
