module Shortwave
  module Provider
    class TagProvider
      def initialize(facade)
        @facade = facade
      end

      def get(name)
        response = @facade.search(name)
        Model::Tag.parse(response).first
      end

      def build(attributes={})
        tag = Model::Tag.new
        attributes.each {|attr, value| tag.send("#{attr}=".to_sym, value) }
        tag
      end
    end
  end
end
