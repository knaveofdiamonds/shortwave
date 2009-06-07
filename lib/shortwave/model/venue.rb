require 'forwardable'

module Shortwave
  module Model
    # A venue that hosts events.
    #
    # === Attributes
    #
    # +id+:: Last.fm id
    # +name+:: Venue name
    # +url+:: Venue url on Last.fm
    # +location+:: Venue's location
    # +city+:: Venue city
    # +street_address+:: Venue street address
    # +country+:: Venue country
    # +postcode+:: Venue post code
    class Venue < BaseModel
      extend Forwardable
      def_delegators(:location, :city, :street_address, :country, :postcode)

      element :id, Integer
      element :name, String
      element :url, String
      has_one :location, "Shortwave::Model::Location"

      # Returns events showing at this venue.
      def events
        link :events, :Event, id
      end

      # Returns past events from this venue.
      def past_events
        link :past_events, :Event, id
      end
    end
  end
end
