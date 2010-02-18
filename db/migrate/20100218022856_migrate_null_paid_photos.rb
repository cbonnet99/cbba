class MigrateNullPaidPhotos < ActiveRecord::Migration
  def self.up
    execute "UPDATE users SET paid_photo=false WHERE paid_photo IS NULL"
    execute "UPDATE users SET paid_highlighted=false WHERE paid_highlighted IS NULL"
  end

  def self.down
  end
end
