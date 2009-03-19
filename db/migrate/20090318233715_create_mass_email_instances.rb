class CreateMassEmailInstances < ActiveRecord::Migration
  def self.up
    create_table :mass_email_instances do |t|
      t.integer :user_id
      t.integer :mass_email_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mass_email_instances
  end
end
