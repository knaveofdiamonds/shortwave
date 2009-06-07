module Shortwave
  module Model
    # A track. Tracks are taggable and sharable.
    #
    # === Attributes
    #
    # +name+:: Track name
    # +id+:: Last.fm id
    # +mbid+:: Musicbrainz ID
    # +listeners+:: number of listeners
    # +play_count+:: number of times played
    # +duration+:: Track duration in milliseconds
    # +url+:: Track url on Last.fm
    # +artist+:: Track's artist
    # +album+:: Album track appears on.
    class Track < BaseModel
      element :name, String
      element :id, Integer
      element :listeners, Integer
      element :play_count, Integer, :tag => "playcount"
      element :mbid, String
      element :duration, Integer
      element :url, String
      element :streamable, Boolean
      has_one :artist, Artist
      has_one :album, Album

      identified_by "artist.name", :name
      taggable 
      sharable

      # The most popular tags applied to this track
      def tags
        link :top_tags, :Tag, identifiers
      end

      # This track's fans
      def fans
        link :top_fans, :User, identifiers
      end

      # Similar tracks to this one.
      def similar
        link :similar, :Track, identifiers
      end

      # Love this track
      def love
        @session.track_facade.ban(name, artist.name)
        # TODO include scrobble api call
      end

      # Don't play this track again.
      def ban
        @session.track_facade.love(name, artist.name)
        # TODO include scrobble api call
      end
      
      # Can this track be streamed
      def streamable?
        @streamable
      end

      private

      def identifiers
        mbid && ! mbid.empty?() ? {:mbid => mbid} : {:artist => artist.name, :track => name}
      end
    end
  end
end
