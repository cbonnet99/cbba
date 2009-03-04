class District < ActiveRecord::Base
  has_many :users
	belongs_to :region

  def self.from_param(param)
    unless param.blank?
      return find(:first, :conditions => ["lower(name) = ?", param.downcase])
    end
  end
  
	def self.options(region_id, selected_district_id=nil)
		old_region_name = ""
		District.find(:all, :include => "region",  :order => "regions.name, districts.name").inject(""){|memo, d|
			if d.region.name != old_region_name
				if selected_district_id.nil? && region_id == d.region.id
					memo << "<option style='font-weight: bold; color: red;' value='r-#{d.region.id}' selected='selected'>#{d.region.name} - All areas</option>"
				else
					memo << "<option style='font-weight: bold; color: red;' value='r-#{d.region.id}'>#{d.region.name} - All areas</option>"
				end
				old_region_name = d.region.name
			end
			if !selected_district_id.nil? && selected_district_id == d.id
				memo << "<option value='#{d.id}' selected='selected'>#{d.full_name}</option>"
			else
				memo << "<option value='#{d.id}'>#{d.full_name}</option>"
			end
		}
	end

	def full_name
		"#{region.name} - #{name}"
	end
end
