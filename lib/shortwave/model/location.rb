module Shortwave
  module Model
    # A location
    #
    # === Attributes
    # +latitude+:: Latitude
    # +longitude+:: Longitude
    # +street_address+:: Street address
    # +city+:: City
    # +postcode+:: Post code
    # +country+:: Country name
    class Location < BaseModel
      tag "location"
      element :latitude, Float, :tag => "geo:point/geo:lat"
      element :longitude, Float, :tag => "geo:point/geo:long"
      element :city, String
      element :country, String
      element :street_address, String, :tag => "street"
      element :postcode, String, :tag => "postalcode"

      # Popular artists in this country. Needs country to be defined
      def artists
        link :top_artists, :Artist, country
      end

      # Popular tracks in this location
      def tracks
        args = [country]
        args << {:location => city} if city
        link :top_tracks, :Track, *args
      end

      # Return events near this location
      def events
        if latitude && longitude
          link :events, :Event, :lat => latitude, :long => longitude
        elsif city
          link :events, :Event, :location => city
        elsif country
          link :events, :Event, :location => country
        end
      end
    end
  end
end
