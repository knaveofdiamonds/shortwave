module Shortwave
  module Model
    # An event.
    #
    # == Attributes
    # +id+:: Last.fm id
    # +name+:: Event name
    # +description+:: Event description
    # +attendance_count+:: Number of last.fm user's attending
    # +review_count+:: Number of reviews
    # +starts_at+:: The start time
    # +url+:: Last.fm site url
    # +venue+:: Event venue
    class Event < BaseModel
      element :id, Integer
      element :description, String
      element :url, String
      element :attendance_count, Integer, :tag => "attendance"
      element :review_count, Integer, :tag => "reviews"
      element :starts_at, Time, :tag => "startDate"
      element :name, String, :tag => "title"
      element :headliner_raw, String, :tag => "artists/headliner"
      element :artists_raw, String, :tag => "artists/artist", :single => false
      has_one :venue, "Model::Venue"

      identified_by :id
      shoutable
      sharable

      # Returns the list of users attending this event
      def attendees
        link :attendees, :User, id
      end

      # Mark the current session user's attendance at this event
      #
      # Possible statuses are +:yes+, +:no+ and +:maybe+
      def attend(status=:yes)
        i = [:yes, :maybe, :no].index(status)
        @session.event_facade.attend(id, i)
        true
      end

      # Returns the headline act for this event
      def headliner
        @headliner ||= artists.detect {|a| a.name == headliner_raw }
      end

      # Returns the list of artists playing at this event
      def artists
        @artists ||= artists_raw.map {|a| @session.artist.build(:name => a) }
      end
    end
  end
end
