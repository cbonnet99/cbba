class CreateExpertApplications < ActiveRecord::Migration
  def self.up
    create_table :expert_applications do |t|
      t.text :expert_presentation
      t.integer :user_id
      t.integer :subcategory_id
      t.string :status, :default => "pending"
      t.timestamps
    end
  end

  def self.down
    drop_table :expert_applications
  end
end
