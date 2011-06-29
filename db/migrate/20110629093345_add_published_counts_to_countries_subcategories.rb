class AddPublishedCountsToCountriesSubcategories < ActiveRecord::Migration
  def self.up
    add_column :countries_subcategories, :published_special_offers_count, :integer
    add_column :countries_subcategories, :published_gift_vouchers_count, :integer
    Country.all.each do |c|
      Subcategory.all.each do |s|
        so_count = c.special_offers.count(:all, :conditions => ["state = 'published' and subcategory_id = ?", self.id])
        gv_count = c.gift_vouchers.count(:all, :conditions => ["state = 'published' and subcategory_id = ?", self.id])
        
        cs = CountriesSubcategory.find_by_country_id_and_subcategory_id(c.id, s.id)
        if cs.nil?
          CountriesSubcategory.create(:country_id => c.id, :subcategory_id => s.id,
                                  :published_special_offers_count => so_count, :published_gift_vouchers_count  => gv_count)
        else
          cs.update_attribute(:published_special_offers_count, so_count)
          cs.update_attribute(:published_gift_vouchers_count, gv_count)
        end
        
      end
    end
  end

  def self.down
    remove_column :countries_subcategories, :published_special_offers_count
    remove_column :countries_subcategories, :published_gift_vouchers_count
  end
end
