class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string :body, :limit => 500
      t.string :state
      t.integer :contact_id
      t.boolean :new_question
  		t.timestamp :published_at
  		t.string :reason_reject, :limit => 500 
  		t.timestamp :rejected_at
  		t.integer :rejected_by_id
      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
