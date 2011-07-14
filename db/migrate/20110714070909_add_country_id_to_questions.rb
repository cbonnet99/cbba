class AddCountryIdToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :country_id, :integer
  end

  def self.down
    remove_column :questions, :country_id
  end
end
