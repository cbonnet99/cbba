class AddProfessionalNewsletterToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :receive_professional_newsletter, :boolean, :default => true
    execute("update users set receive_professional_newsletter=true") 
  end

  def self.down
    remove_column :users, :receive_professional_newsletter
  end
end
