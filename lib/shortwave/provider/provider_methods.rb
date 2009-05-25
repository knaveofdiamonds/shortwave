module Shortwave
  module Provider

    module ProviderMethods
      # Returns a tag provider.
      def tag
        @tag_provider ||= Provider::TagProvider.new(tag_facade)
      end

      def tag_facade
        @tag_facade ||= Facade::Tag.new(self)
      end
    end

  end
end
