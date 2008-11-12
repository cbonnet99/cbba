class AddFreeMemberAttributes < ActiveRecord::Migration
  def self.up
		add_column :users, :free_listing, :boolean
		add_column :users, :business_name, :string
		add_column :users, :address1, :string
		add_column :users, :suburb, :string
		add_column :users, :city, :string
		add_column :users, :district_id, :integer
		add_column :users, :phone, :string
		add_column :users, :mobile, :string
    create_table :districts do |t|
      t.string :name
			t.integer :region_id
      t.timestamps
    end
  end

  def self.down
    drop_table :districts
		remove_column :users, :free_listing
		remove_column :users, :business_name
		remove_column :users, :address1
		remove_column :users, :suburb
		remove_column :users, :city
		remove_column :users, :district_id
		remove_column :users, :phone
		remove_column :users, :mobile
  end
end
