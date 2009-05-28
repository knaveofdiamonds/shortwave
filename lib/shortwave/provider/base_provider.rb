module Shortwave
  module Provider
    class BaseProvider
      # Create a provider with a facade
      def initialize(facade)
        @klass  = Model.const_get(self.class.name.split("::").last.sub("Provider",''))
        @facade = facade
      end

      # Builds a model object.
      def build(attributes)
        model = @klass.new
        attributes.each {|attr, value| model.send("#{attr}=".to_sym, value) }
        model.session = @facade.session
        model
      end

      protected

      def parse_model(response)
        model = @klass.parse(response, :single => true)
        model.session = @facade.session
        model
      end

      def parse_collection(response)
        @klass.parse(response).each {|model| model.session = @facade.session }
      end
    end
  end
end
