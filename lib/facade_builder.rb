require 'nokogiri'

module Shortwave
  module Facade
    module Build
      METHOD_NAME_CSS = "#wstitle ~ h1"
      PARAMETER_CSS   = "#wsdescriptor h2 ~ .param"
      SAMPLE_CSS      = "#sample pre"
      DESCRIPTION_CSS = ".wsdescription"
      METHOD_TYPE_CSS = "#wsdescriptor"

      COMBINED_PARAMS = /^(.+)\[(.+)\]$/
      PARAMETER_TEXT  = /\s*\(([^\)]+)\)\s*:\s*(.*)/
      IN_WORD_CAPS    = /(.)([A-Z])/
      STARTS_WITH_GET = /^.+\.(get)?/

      # Various Helper methods that belong on String
      module StringExtensions
        # Convert a string like FooBar to foo_bar
        def camel_to_snake
          gsub(IN_WORD_CAPS,"\\1_\\2").tr('A-Z','a-z')
        end
      end
      String.send(:include, StringExtensions)


      class Compiler
        def initialize
          @lines = []
        end

        def compile(node)
          @lines << "# #{node.description}" if node.description
          @lines << "def #{node.name}"
          @lines << "end"
          @lines
        end
      end

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

          doc.css(PARAMETER_CSS).map do |node|
            name = node.text.strip
            if match = name.match(COMBINED_PARAMS)
              match[2].split("|").map {|v| make_parameter(node, match[1] + v) }
            else
              make_parameter(node, name)
            end
          end.flatten
        end

        # Returns true if this parameter is required
        def required?
          @required
        end

        private

        def self.make_parameter(node, name)
          if match = node.next.text.match(PARAMETER_TEXT)
            self.new(name.to_sym, match[1].start_with?("Required"), match[2])
          else
            self.new(name.to_sym, true, "")
          end
        end
      end


      # Represents an available method in the Last FM 'rest' api. Provides information
      # about how to call the method.
      class RemoteMethod
        attr_reader :name, :remote_name, :parameters, :description, :http_method, :sample_response

        # Creates a RemoteMethod, given an html page from the Last FM API documentation.
        def initialize(html)
          doc = Nokogiri::HTML(html)

          @remote_name     = doc.css(METHOD_NAME_CSS).text.strip
          @name            = @remote_name.sub(STARTS_WITH_GET,'').camel_to_snake.to_sym
          @parameters      = Parameter.parse(doc)
          @description     = doc.css(DESCRIPTION_CSS).text.strip
          @http_method     = doc.css(METHOD_TYPE_CSS).text.include?("HTTP POST") ? :post : :get
          @sample_response = doc.css(SAMPLE_CSS).text.strip
        end
      end
    end
  end
end
