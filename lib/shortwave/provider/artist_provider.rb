module Shortwave
  module Provider
    # Produces artist objects.
    #
    # You should generally use an instance of this class provided by a session:
    # session.artist
    class ArtistProvider < BaseProvider
      # Returns an artist, given either an artist's name or a musicbrainz id
      def get(identifier)
        key = (identifier =~ /[\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12}/) ? :mbid : :artist
        parse_model @facade.info(key => identifier)
      end

      # Searches for an artist by name.
      def search(name)
        parse_collection @facade.search(name)
      end
    end
  end
end
