class AddFieldsToExpertApplication < ActiveRecord::Migration
  def self.up
    add_column :expert_applications, :raise_profile, :boolean
    add_column :expert_applications, :basic_articles, :boolean
    add_column :expert_applications, :weekly_question, :boolean
  end

  def self.down
    remove_column :expert_applications, :raise_profile
    remove_column :expert_applications, :basic_articles
    remove_column :expert_applications, :weekly_question
  end
end
