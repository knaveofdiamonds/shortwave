module Shortwave
  module Model
    # A Last.fm user group.
    #
    # === Attributes
    #
    # name:: the group name
    class Group < BaseModel
      attr_accessor :name
      identified_by :name

      # Returns the group's members. Currently only 50 users are returned
      def members
        link :members, "User", name
      end

      # Returns the most popular albums from this group for the last week
      def albums
        link :weekly_album_chart, "Album", name
      end

      # Returns the most popular artists from this group for the last week
      def artists
        link :weekly_artist_chart, "Artist", name
      end

      # Returns the most popular tracks from this group for the last week
      def tracks
        link :weekly_track_chart, "Track", name
      end
    end
  end
end
