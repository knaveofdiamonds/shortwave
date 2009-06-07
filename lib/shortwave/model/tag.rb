module Shortwave
  module Model
    # A Last.fm tag
    #
    # ===Attributes
    #
    # +name+:: Tag text
    # +count+:: Number of times this tag has been applied
    # +url+:: URL on Last.fm site
    class Tag < BaseModel
      element :name, String
      element :count, Integer
      element :url, String
      element :streamable, Boolean

      # Can music be streamed from this tag?
      def streamable?
        streamable
      end

      # Returns similar tags to this one.
      def similar
        link :similar, :Tag, name
      end
      
      # Returns the most popular albums tagged with this tag.
      def albums
        link :top_albums, :Album, name
      end
      
      # Returns the most popular artists tagged with this tag.
      def artists
        link :top_artists, :Artist, name
      end
      
      # Returns the most popular tracks tagged with this tag.
      def tracks
        link :top_tracks, :Track, name
      end

      # Returns the tag text
      def to_s
        name
      end
    end
  end
end
