module Shortwave
  module Provider
    class Base
      def initialize(klass, facade)
        @klass  = klass
        @facade = facade
      end

      def build(attributes)
        model = @klass.new
        attributes.each {|attr, value| model.send("#{attr}=".to_sym, value) }
        model.session = @facade.session
        model
      end

      protected

      def parse_model(response, options)
        model = @klass.parse(response, options)
        model.session = @facade.session
        model
      end
    end
  end
end
