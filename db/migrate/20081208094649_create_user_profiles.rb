class CreateUserProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :state, :default => "draft"
      t.timestamps
    end
		UserProfile.all.each do |a|
			a.update_attribute :state, 'draft'
		end
  end

  def self.down
    drop_table :user_profiles
  end
end
