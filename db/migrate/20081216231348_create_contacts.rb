class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :email
      t.boolean :receive_newsletter
      t.string :first_name
      t.string :last_name
      t.integer :region_id
      t.integer :district_id

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
