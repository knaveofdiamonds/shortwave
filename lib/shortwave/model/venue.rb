module Shortwave
  module Model
    class Location < BaseModel
      tag "geo:point"
      element :latitude, Float, :tag => "geo:lat"
      element :longitude, Float, :tag => "geo:long"
    end

    class Venue < BaseModel
      element :id, Integer
      element :name, String
      element :url, String
      element :city, String, :tag => "location/city"
      element :country, String, :tag => "location/country"
      element :street_address, String, :tag => "location/street"
      element :postcode, String, :tag => "location/postalcode"
      has_one :location, Location, :tag => "location/geo:point"

      def events
        response = @session.venue_facade.events(id)
        Event.parse(response).each {|e| e.session = @session }
      end
    end
  end
end
