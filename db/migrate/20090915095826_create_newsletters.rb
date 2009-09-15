class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string :title
      t.text :main_article
      t.text :competition
      t.text :bam_news
      t.text :upcoming_events
      t.text :quotation_quiz

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletters
  end
end
