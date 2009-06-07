module Shortwave
  module Model
    class User < BaseModel
      element :name, String
      element :id, Integer
      element :real_name, String, :tag => "realname"
      element :url, String
      element :image, String
      element :language, String, :tag => "lang"
      element :country, String
      element :age, Integer
      element :gender, String
      element :subscriber, Boolean
      element :play_count, Integer, :tag => "playcount"

      identified_by :name
      shoutable
      include WeeklyCharts

      # Returns the events that this user is attending.
      def events
        link :events, :Event, name
      end

      # Events this user may be interested in.
      def recommended_events
        link :recommended_events, :Event
      end

      # Artists this user may be interested in.
      def recommended_artists
        link :recommended_artists, :Artist
      end
    end
  end
end
