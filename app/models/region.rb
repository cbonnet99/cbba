class Region < ActiveRecord::Base
  has_many :users
	has_many :districts
  belongs_to :country

  after_create :create_slug
  before_update :update_geocodes

  DEFAULT_NZ_LATITUDE = -41.3
  DEFAULT_NZ_LONGITUDE = 172.5

  def update_geocodes
    if self.name_changed?
      locate
    end
  end

  def locate
      address = [name, country.name].reject{|o| o.blank?}.join(", ")
      begin
        location = ImportUtils.geocode(address)
        logger.debug("====== Geocoding: #{address}: #{location.inspect}")
        self.latitude = location.latitude
        self.longitude = location.longitude
      rescue Graticule::AddressError
        logger.warn("Couldn't geocode address: #{address}")
      end
  end

  def self.from_param(param)
    unless param.blank?
      return find(:first, :conditions => ["lower(name) = ?", param.downcase])
    end
  end
  
  def to_param
    slug
  end

	def create_slug
		self.update_attribute(:slug, computed_slug)
	end

	def computed_slug
		name.parameterize
	end
end
