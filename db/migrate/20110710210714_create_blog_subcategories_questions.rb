class CreateBlogSubcategoriesQuestions < ActiveRecord::Migration
  def self.up
    create_table :blog_subcategories_questions do |t|
      t.integer :question_id
      t.integer :blog_subcategory_id

      t.timestamps
    end
  end

  def self.down
    drop_table :blog_subcategories_questions
  end
end
