class AddFeatureWarningSentToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :feature_warning_sent, :datetime
  end

  def self.down
    remove_column :users, :feature_warning_sent
  end
end
