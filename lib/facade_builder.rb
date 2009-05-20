require 'nokogiri'

module Shortwave
  module Facade
    module Build

      # A parameter used in a Last FM api method call.
      class Parameter
        attr_reader :name, :description

        def initialize(name, required, description)
          @name, @required, @description = name, required, description
        end

        # Returns an array of Parameters, given an HTML page from the Last FM API 
        # method documentation
        def self.parse(html)
          doc = html.kind_of?(Nokogiri::HTML::Document) ? html : Nokogiri::HTML(html)
          doc.css("#wsdescriptor h2 ~ .param").map do |node|
            name = node.text.strip.to_sym
            match = node.next.text.match(/\s*\(([^\)]+)\)\s*:\s*(.*)/)
            if match
              self.new(name, match[1] == "Required", match[2])
            else
              self.new(name, true, "")
            end
          end
        end

        # Returns true if this parameter is required
        def required?
          @required
        end
        
        def to_sym
          @name
        end
      end

      # Represents an available method in the Last FM 'rest' api. Provides information
      # about how to call the method.
      class RemoteMethod
        attr_reader :name, :remote_name, :parameters, :description, :http_method, :sample_response

        # Creates a RemoteMethod, given an html page from the Last FM API documentation.
        def initialize(html)
          doc = Nokogiri::HTML(html)

          @remote_name = doc.css("#wstitle ~ h1").text.strip
          @name = @remote_name.sub(/^.+\.(get)?/,'').gsub(/(.)([A-Z])/,"\\1_\\2").tr('A-Z','a-z').to_sym
          @parameters = Parameter.parse(doc)
          @description = doc.css(".wsdescription").text.strip
          @http_method = doc.css("#wsdescriptor").text.include?("HTTP POST request") ? :post : :get
          @sample_response = doc.css("#sample pre").text.strip
        end
      end
    end
  end
end
