class AddWorkflowFieldsToSpecialOffers < ActiveRecord::Migration
  def self.up
		add_column :special_offers, :state, :string, :default => 'draft'
		add_column :special_offers, :published_at, :timestamp
		add_column :special_offers, :reason_reject, :text
		add_column :special_offers, :rejected_at, :timestamp
		add_column :special_offers, :rejected_by_id, :integer
		add_column :special_offers, :comment_approve, :text
		add_column :special_offers, :approved_at, :timestamp
		add_column :special_offers, :approved_by_id, :integer
		SpecialOffer.all.each do |so|
			so.update_attribute :state, 'draft'
		end

  end

  def self.down
		remove_column :special_offers, :state
		remove_column :special_offers, :published_at
		remove_column :special_offers, :reason_reject
		remove_column :special_offers, :rejected_at
		remove_column :special_offers, :rejected_by_id
		remove_column :special_offers, :comment_approve
		remove_column :special_offers, :approved_at
		remove_column :special_offers, :approved_by_id
  end
end
