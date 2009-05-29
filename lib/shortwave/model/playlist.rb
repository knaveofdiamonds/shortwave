module Shortwave
  module Model
    class Playlist < BaseModel
      element :id, Integer
      element :title, String
      element :description, String
      element :created_at, Time, :tag => "date"
      element :size, Integer
      element :duration, Integer
      element :streamable, Boolean
      element :creator_url, String, :tag => "creator"
      element :url, String

      def streamable?
        @streamable
      end

      def add_track(track)
        @session.playlist_facade.add_track(id, track.name, track.artist_name)
      end
    end
  end
end
