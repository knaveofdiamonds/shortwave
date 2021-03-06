require 'nokogiri'
require 'httparty'
require 'yaml'

module Shortwave
  module Facade
    module Build
      METHOD_NAME_CSS = "#wstitle ~ h1"
      PARAMETER_CSS   = "#wsdescriptor h2 ~ .param"
      SAMPLE_CSS      = "#sample pre"
      DESCRIPTION_CSS = ".wsdescription"
      METHOD_TYPE_CSS = "#wsdescriptor"
      REMOTE_CLASS    = "li.package"

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


      # Helper methods for constructing the Facades
      class FacadeBuilder
        def remote_method_definitions(location)
          return @method_definitions if @method_definitions
          if File.exists?( location )
            @method_definitions = YAML.load(File.read(location))
          else
            response = Build::DocumentationRemote.scrape_remote_method_index
            File.open(location, "w") {|fh| fh.write(response.to_yaml) }
            @method_definitions = response
          end
        end
      end

      # A remote facade for the Last FM html documentation
      class DocumentationRemote
        include HTTParty
        base_uri "http://last.fm"

        def self.scrape_remote_method_index
          html = get("/api/intro")
          Nokogiri::HTML(html).css(REMOTE_CLASS).inject({}) do |hsh, node|
            hsh[node.text] = node.next.next.css("a").inject({}) do |h, anchor|
              h[anchor.text] = anchor["href"]
              h
            end
            hsh
          end
        end
      end


      # The class of a RemoteFacade to be generated
      class RubyClass
        attr_reader :name, :methods

        def initialize(name)
          @name = name
          @methods = []
        end
      end


      # A ruby method in a RemoteFacade that will be generated
      class RubyMethod
        attr_accessor :signature
        attr_reader   :comment, :body, :name

        def initialize(node)
          @comment = []
          @body = []
          @node = node
          @parameters = node.parameters || []
          @required, @optional = (@parameters).partition {|p| p.required? }
          @required.reject! {|p| [:api_key, :api_sig, :sk].include?(p.name) }

          build_comment
          build_signature
          build_body
          self
        end

        private

        def build_body
          mode = if @parameters.any? {|p| p.name == :sk }
                   :session
                 elsif @parameters.any? {|p| p.name == :api_sig }
                   :signed
                 else
                   :standard
                 end

          get_line = "#{@node.http_method}(:#{mode}, {:method => \"#{@node.remote_name}\""
          @required.each {|p| get_line << ", :#{p.name} => #{p.name}" }
          get_line << "}"
          get_line << ".merge(options)" unless @optional.empty?
          get_line << ")"
          @body << get_line
        end

        def build_signature
          @signature = "#{@node.name}"
          unless @node.parameters.nil? || @node.parameters.empty?
            params = @required.map {|p| p.name }
            params << "options={}" unless @optional.empty?
            @signature << "(" << params.join(", ") << ")"
          end
        end

        def build_comment
          comment << "# #{@node.description}" if @node.description

          unless @required.empty?
            comment << "#"
            @required.each {|p| comment << "# +#{p.name}+:: #{p.description}" }
          end

          unless @optional.empty?
            comment << "#"
            comment << "# <b>Options</b>"
            @optional.each {|p| comment << "# +#{p.name}+:: #{p.description}" }
          end
        end
      end


      # A parameter used in a Last FM api method call.
      class Parameter
        attr_reader :name, :description

        def initialize(name, required, description)
          @name, @required, @description = name, required, description.gsub(/\s+/, ' ')
        end

        # Returns an array of Parameters, given an HTML page from the Last FM API 
        # method documentation
        def self.parse(html)
          doc = html.kind_of?(Nokogiri::HTML::Document) ? html : Nokogiri::HTML(html)

          doc.css(PARAMETER_CSS).map do |node|
            name = node.text.strip
            unless name.nil? || name.empty?
              if match = name.match(COMBINED_PARAMS)
                match[2].split("|").map {|v| make_parameter(node, match[1] + v) }
              else
                make_parameter(node, name)
              end
            end
          end.flatten.compact
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
          @description     = doc.css(DESCRIPTION_CSS).text.strip.gsub(/\s+/, ' ')
          @http_method     = doc.css(METHOD_TYPE_CSS).text.include?("HTTP POST") ? :post : :get
          @sample_response = doc.css(SAMPLE_CSS).text.strip
        end
      end
    end
  end
end
