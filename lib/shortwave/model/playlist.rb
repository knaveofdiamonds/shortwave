module Shortwave
  module Model
    # A playlist
    #
    # === Attributes
    #
    # +id+:: id
    # +title+:: title
    # +description+:: description
    # +created_at+:: Creation time
    # +size+:: Number of tracks in the playlist
    # +duration+:: length in milliseconds of the playlist
    # +creator_url+:: Last.fm url of creator
    # +url+:: Last.fm url of playlist
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

      # This can only be called on a user's own playlist
      def add_track(track)
        @session.playlist_facade.add_track(id, track.name, track.artist_name)
      end
    end
  end
end
