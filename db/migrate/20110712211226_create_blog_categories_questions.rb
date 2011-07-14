class CreateBlogCategoriesQuestions < ActiveRecord::Migration
  def self.up
    create_table :blog_categories_questions do |t|
      t.integer :question_id
      t.integer :blog_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :blog_categories_questions
  end
end
