module Shortwave
  module Provider
    # Produces album objects.
    #
    # You should generally use an instance of this class provided by a session:
    # session.album
    class AlbumProvider < BaseProvider
      # Gets an album, given a musicbrainz id.
      def get(mbid)
        parse_model @facade.info(:mbid => mbid)
      end

      # Gets an album, given an artist name and an album name
      def get_by_name(artist, name)
        parse_model @facade.info(:artist => artist, :album => name)
      end

      # Searches for an album by name.
      def search(name)
        parse_collection @facade.search(name)
      end
    end
  end
end
