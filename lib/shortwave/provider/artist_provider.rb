module Shortwave
  module Provider
    class ArtistProvider < Base
      def get(identifier)
        key = (identifier =~ /[\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12}/) ? :mbid : :artist
        response = @facade.info(key => identifier)
        parse_model response, :single => true
      end
    end
  end
end
