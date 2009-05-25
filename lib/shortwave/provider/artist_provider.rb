module Shortwave
  module Provider
    class ArtistProvider < Base
      def initialize(facade)
        super(Model::Artist, facade)
      end

      def get(identifier)
        response = @facade.info(:artist => identifier)
        parse_model response, :single => true
      end
    end
  end
end
