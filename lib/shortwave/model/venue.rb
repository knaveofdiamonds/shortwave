require 'forwardable'

module Shortwave
  module Model
    # A venue that hosts events.
    class Venue < BaseModel
      extend Forwardable
      def_delegators(:location, :city, :street_address, :country, :postcode)

      element :id, Integer
      element :name, String
      element :url, String
      has_one :location, "Shortwave::Model::Location"

      # Returns upcoming events at this venue
      def events
        response = @session.venue_facade.events(id)
        Event.parse(response).each {|e| e.session = @session }
      end
    end
  end
end
