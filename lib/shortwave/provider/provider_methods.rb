module Shortwave
  module Provider
    # Intended to be mixed in to authentication classes
    module ProviderMethods
      [:tag, :album, :artist].each do |name|
        klass_name = name.to_s.capitalize
        module_eval <<-EOV
          def #{name}
            @#{name}_provider ||= Provider::#{klass_name}Provider.new(#{name}_facade)
          end

          def #{name}_facade
            @#{name}_facade ||= Facade::#{klass_name}.new(self)            
          end
        EOV
      end
    end
  end
end
