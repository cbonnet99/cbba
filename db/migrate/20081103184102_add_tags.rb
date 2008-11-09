class AddTags < ActiveRecord::Migration
  def self.up 
    create_table :taggings do |t| 
      t.integer :taggable_id
      t.integer :tag_id
      t.string :taggable_type
    end 
    create_table :tags do |t| 
      t.string :name
    end 
  end 
  
  def self.down 
    drop_table :taggings 
    drop_table :tags 
  end 
end 