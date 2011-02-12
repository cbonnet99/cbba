class DeleteExpertApplications < ActiveRecord::Migration
  def self.up
    drop_table :expert_applications
  end

  def self.down
    create_table :expert_applications do |t|
      t.text :expert_presentation
      t.integer :user_id
      t.integer :subcategory_id
      t.string :status, :default => "pending"
      t.timestamps
    end
  end
end
