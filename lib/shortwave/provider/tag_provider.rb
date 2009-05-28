module Shortwave
  module Provider
    class TagProvider < BaseProvider
      # Returns a tag named "name"
      def get(name)
        parse_model @facade.search(name)
      end

      # Returns the most popular tags from Last.fm
      def popular
        parse_collection @facade.top_tags
      end
    end
  end
end
