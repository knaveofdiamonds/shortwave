module Shortwave
  module Model
    class Location < BaseModel
    end

    class Venue < BaseModel
      element :id, Integer
      element :name, String
      element :url, String
      element :city, String, :tag => "location/city"
      element :country, String, :tag => "location/country"
      has_one :location, Location

      def events
        response = @session.venue_facade.events(id)
        Event.parse(response).each {|e| e.session = @session }
      end
    end
  end
end
