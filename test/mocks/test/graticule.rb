module Graticule #:nodoc:
    def self.service(name)
      return Geocoder::Google
    end
end
module Graticule #:nodoc:
  module Geocoder #:nodoc:
    class VirtualLocation < Struct.new( :latitude, :longitude)
    end
    class Google
      def initialize(key)
      end
      def locate(address)
        if address =="Test Address"
          raise Graticule::AddressError
        else
          location = VirtualLocation.new
          location.latitude = -75
          location.longitude = 30
          return location
        end
      end
    end
  end
end