module Shortwave
  module Provider
    class ArtistProvider < BaseProvider
      # Returns an artist, given either an artist's name or a musicbrainz id
      def get(identifier)
        key = (identifier =~ /[\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12}/) ? :mbid : :artist
        parse_model @facade.info(key => identifier)
      end
    end
  end
end
