module Shortwave
  module Provider
    class TagProvider < Base
      def initialize(facade)
        super(Model::Tag, facade)
      end

      def get(name)
        response = @facade.search(name)
        parse_model response, :single => true
      end

      def popular
        response = @facade.top_tags
        Model::Tag.parse(response).each {|tag| tag.session = @facade.session }
      end
    end
  end
end
