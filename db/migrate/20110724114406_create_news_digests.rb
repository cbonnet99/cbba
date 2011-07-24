class CreateNewsDigests < ActiveRecord::Migration
  def self.up
    create_table :news_digests do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :news_digests
  end
end
