module Shortwave
  module Model
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

      def streamable?
        @streamable
      end
    end
  end
end
