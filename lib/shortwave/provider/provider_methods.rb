module Shortwave
  module Provider

    module ProviderMethods
      # Returns a tag provider.
      def tag
        @tag_provider ||= Provider::TagProvider.new(tag_facade)
      end

      def artist
        @artist_provider ||= Provider.ArtistProvider.new(artist_facade)
      end

      def tag_facade
        @tag_facade ||= Facade::Tag.new(self)
      end

      def artist_facade
        @artist_facade ||= Facade::Artist.new(self)
      end
    end

  end
end
