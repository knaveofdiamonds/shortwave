module Shortwave
  module Model
    class Artist
      include HappyMapper
      
      tag 'artist'
      element :name, String
      element :mbid, String
      element :url, String
      element :streamable, Boolean
      element :play_count, Integer, :tag => "stats/playcount"
      element :listeners, Integer, :tag => "stats/listeners"
      element :biography_summary, String, :tag => "bio/content"
      element :biography, String, :tag => "bio/content"

      attr_writer :session

      private

      def facade
        @session.tag_facade
      end
    end
  end
end
