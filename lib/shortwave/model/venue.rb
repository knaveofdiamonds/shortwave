module Shortwave
  module Model
    # A venue that hosts events.
    class Venue < BaseModel
      element :id, Integer
      element :name, String
      element :url, String
      element :city, String, :tag => "location/city"
      element :country, String, :tag => "location/country"
      element :street_address, String, :tag => "location/street"
      element :postcode, String, :tag => "location/postalcode"
      has_one :location, "Shortwave::Model::Location", :tag => "location/geo:point"

      # Returns upcoming events at this venue
      def events
        response = @session.venue_facade.events(id)
        Event.parse(response).each {|e| e.session = @session }
      end
    end
  end
end
