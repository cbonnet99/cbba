class CreateCountriesSubcategories < ActiveRecord::Migration
  def self.up
    create_table :countries_subcategories do |t|
      t.integer :country_id
      t.integer :subcategory_id
      t.integer :published_articles_count
      t.timestamps
    end
    Subcategory.all.each do |subcat|
      Country.all.each do |country|
        published_articles_count = country.articles.published.count(:all, 
          :include => "articles_subcategories", 
          :conditions => ["articles_subcategories.article_id = articles.id and articles_subcategories.subcategory_id = ?",
             subcat.id])
        cs = CountriesSubcategory.find_by_country_id_and_subcategory_id(country.id, subcat.id)
        if cs.nil?
          CountriesSubcategory.create(:country_id => country.id, :subcategory_id => subcat.id,
                                  :published_articles_count => published_articles_count)
        else
          cs.update_attribute(:published_articles_count, published_articles_count)
        end
      end
    end
  end

  def self.down
    drop_table :countries_subcategories
  end
end
