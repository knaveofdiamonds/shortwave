module Shortwave
  module Provider
    class AlbumProvider < BaseProvider
      def get_by_name(artist, name)
        response = @facade.info(:artist => artist, :album => name)
        parse_model response, :single => true
      end

      def search(name)
        parse_collection @facade.search(name)
      end
    end
  end
end
