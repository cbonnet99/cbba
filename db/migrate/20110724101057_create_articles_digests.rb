class CreateArticlesDigests < ActiveRecord::Migration
  def self.up
    create_table :articles_digests do |t|
      t.integer :article_id
      t.integer :digest_id

      t.timestamps
    end
  end

  def self.down
    drop_table :articles_digests
  end
end
