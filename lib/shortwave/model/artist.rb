module Shortwave
  module Model
    # An artist. Artists are taggable, shoutable and sharable by a user.
    #
    # === Attributes
    #
    # +name+:: Artist name
    # +mbid+:: Musicbrainz ID
    # +url+:: Url of artist page on the Last.fm site
    # +play_count+:: The number of times this artist has been played
    # +listeners+:: The number of listeners this artist has
    # +biography_summary+:: Textual description of this artist
    # +biography+:: Full textual description of this artist
    # +images+:: Images of this artist
    class Artist < BaseModel
      element :name, String
      element :mbid, String
      element :url, String
      element :streamable, Boolean
      element :play_count, Integer, :tag => "stats/playcount"
      element :listeners, Integer, :tag => "stats/listeners"
      element :biography_summary, String, :tag => "bio/content"
      element :biography, String, :tag => "bio/content"
      element :images, String, :tag => "image", :single => false

      identified_by :name
      taggable
      shoutable
      sharable

      # Events this artist is playing at.
      def events
        link :events, :Event, name
      end

      # Artists similar to this one.
      def similar
        link :similar, :Artist, name
      end

      # This artist's top albums
      def albums
        link :top_albums, :Album, name
      end

      # This artist's top fans
      def fans
        link :top_fans, :User, name
      end

      # This artist's top tags
      def tags
        link :top_tags, :Tag, name
      end

      # This artist's top tracks
      def tracks
        link :top_tracks, :Track, name
      end
    end
  end
end
