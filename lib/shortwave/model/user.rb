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

      # Returns the events a user has attended.
      def past_events
        link :past_events, :Event, name
      end

      # Returns the recent tracks played by this user.
      def recent_tracks
        link :recent_tracks, :Track, name
      end

      # Returns tracks a user has "loved".
      def loved_tracks
        link :loved_tracks, :Track, name
      end

      # Returns other Last.fm users with similar taste to this user.
      def neighbours
        link :neighbours, :User, name
      end

      # Returns the first 50 of a user's friends on Last.fm
      def friends
        link :friends, :User, name
      end

      # Returns a user's playlists
      def playlists
        link :playlists, :Playlist, name
      end

      # Returns events this user may be interested in.
      def recommended_events
        link :recommended_events, :Event
      end

      # Returns the first 50 artists this user may be interested in.
      def recommended_artists
        link :recommended_artists, :Artist
      end

      def compare_with(other_user)
        Comparison.parse(@session.tasteometer_facacde.compare("user", "user", name, other_user.name), :single => true)
      end
    end
  end
end
