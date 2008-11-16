class AddIntroductionAndSubcategoriesToArticles < ActiveRecord::Migration
  def self.up
		add_column :articles, :introduction, :string
		add_column :articles, :subcategory1_id, :integer
		add_column :articles, :subcategory2_id, :integer
		add_column :articles, :subcategory3_id, :integer
  end

  def self.down
		remove_column :articles, :introduction
		remove_column :articles, :subcategory1_id
		remove_column :articles, :subcategory2_id
		remove_column :articles, :subcategory3_id
  end
end
