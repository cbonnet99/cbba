require 'csv'

class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|
      t.text :body
      t.string :author
      t.boolean :homepage_featured
      t.datetime :last_homepage_featured_at
      t.timestamps
    end
    puts "Importing quotes..."
    CSV.foreach("#{RAILS_ROOT}/csv/quotes.csv") do |row|
      puts "... #{row[1]}"
      Quote.create(:body => row[0], :author => row[1])
    end
  end

  def self.down
    drop_table :quotes
  end
end
