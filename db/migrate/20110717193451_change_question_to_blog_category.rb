class ChangeQuestionToBlogCategory < ActiveRecord::Migration
  def self.up
    drop_table :blog_categories_questions
    add_column :questions, :blog_category_id, :integer
  end

  def self.down
    remove_column :questions, :blog_category_id
    create_table :blog_categories_questions do |t|
      t.integer :question_id
      t.integer :blog_category_id

      t.timestamps
    end
  end
end
