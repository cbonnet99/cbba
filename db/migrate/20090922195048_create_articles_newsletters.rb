class CreateArticlesNewsletters < ActiveRecord::Migration
  def self.up
    create_table :articles_newsletters do |t|
      t.integer :article_id
      t.integer :newsletter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :articles_newsletters
  end
end
