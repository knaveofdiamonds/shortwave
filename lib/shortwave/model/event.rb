module Shortwave
  module Model
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

      identified_by :id
      shoutable
      sharable

      link_to "Shout", :shouts
      link_to "User", :attendees

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
