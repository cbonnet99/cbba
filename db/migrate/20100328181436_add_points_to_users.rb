class AddPointsToUsers < ActiveRecord::Migration
  def self.up
    add_column :subcategories_users, :points, :integer
    SubcategoriesUser.all.each do |su|
      su.destroy if su.user.nil?
    end
    SubcategoriesUser.all.each do |su|
      su.update_attribute(:points, su.user.compute_points(su.subcategory))
    end
  end

  def self.down
    remove_column :subcategories_users, :points
  end
end
