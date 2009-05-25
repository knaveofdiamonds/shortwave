module Shortwave
  module Provider
    class TagProvider
      def initialize(facade)
        @facade = facade
      end

      def get(name)
        response = @facade.search(name)
        tag = Model::Tag.parse(response).first
        tag.session = @facade.session
        tag
      end

      def popular
        response = @facade.top_tags
        Model::Tag.parse(response).each {|tag| tag.session = @facade.session }
      end

      def build(attributes={})
        tag = Model::Tag.new
        attributes.each {|attr, value| tag.send("#{attr}=".to_sym, value) }
        tag.session = @facade.session
        tag
      end
    end
  end
end
