require 'nokogiri'

module Shortwave
  class FacadeBuilder
    attr_reader :name, :remote_name, :parameters, :description, :http_method

    def initialize(html)
      doc = Nokogiri::HTML(html)

      @remote_name = doc.css("#wstitle ~ h1").text.strip
      @name = @remote_name.sub(/^.+\.(get)?/,'').gsub(/(.)([A-Z])/,"\\1_\\2").tr('A-Z','a-z').to_sym
      @parameters = doc.css("#wsdescriptor h2 ~ .param").map {|node| node.text.strip.to_sym }
      @description = doc.css(".wsdescription").text.strip
      @http_method = doc.css("#wsdescriptor").text.include?("HTTP POST request") ? :post : :get
    end
  end
end
