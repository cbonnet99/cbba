class CreateHowTos < ActiveRecord::Migration
  def self.up
    create_table :how_tos do |t|
      t.string :title
      t.string :summary
      t.string :step_label
      t.timestamp :published_at
      t.text :reason_reject
      t.timestamp :rejected_at
      t.integer :rejected_by_id
      t.text :comment_approve
      t.timestamp :approved_at
      t.integer :approved_by_id
      t.timestamps
    end
		create_table :how_tos_subcategories do |t|
			t.timestamps
			t.integer :subcategory_id
			t.integer :how_to_id
      t.integer :position
		end
		add_index :how_tos_subcategories, :subcategory_id
		add_index :how_tos_subcategories, :how_to_id
		create_table :how_tos_categories do |t|
			t.timestamps
			t.integer :category_id
			t.integer :how_to_id
      t.integer :position
		end
		add_index :how_tos_categories, :category_id
		add_index :how_tos_categories, :how_to_id
  end

  def self.down
    drop_table :how_tos
  end
end
