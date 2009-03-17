class CreateGiftVouchers < ActiveRecord::Migration
  def self.up
    create_table :gift_vouchers do |t|
      t.string :title
      t.text :description
      t.integer :author_id
      t.string :slug
      t.string :state, :string, :default => 'draft'
      t.timestamp :published_at
      t.timestamp :reason_reject
      t.timestamp :rejected_at
      t.integer :rejected_by_id
      t.text :comment_approve
      t.timestamp :approved_at
      t.integer :approved_by_id
      t.timestamps
    end
  end

  def self.down
    drop_table :gift_vouchers
  end
end
