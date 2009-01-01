class CreateHowToSteps < ActiveRecord::Migration
  def self.up
    create_table :how_to_steps do |t|
      t.integer :how_to_id
      t.string :title
      t.text :body
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :how_to_steps
  end
end
