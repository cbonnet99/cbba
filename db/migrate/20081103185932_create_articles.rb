class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :slug
      t.integer :author_id

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
