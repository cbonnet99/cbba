class AddStateToArticles < ActiveRecord::Migration
  def self.up
		add_column :articles, :state, :string, :default => 'draft'
		add_column :articles, :published_at, :timestamp
		add_column :articles, :reason_reject, :text
		add_column :articles, :rejected_at, :timestamp
		add_column :articles, :rejected_by_id, :integer
		Article.all.each do |a|
			a.update_attribute :state, 'draft'
		end

  end

  def self.down
		remove_column :articles, :state
		remove_column :articles, :published_at
		remove_column :articles, :reason_reject
		remove_column :articles, :rejected_at
		remove_column :articles, :rejected_by_id
  end
end
