require 'nokogiri'

module Shortwave
  class FacadeBuilder
    def initialize(html)
      @doc = Nokogiri::HTML(html)
    end

    def parameters
      @doc.css("#wsdescriptor h2 ~ .param").map {|node| node.text.strip.to_sym }
    end
    
    def name
      @doc.css("#wstitle ~ h1").text.strip
    end

    def description
      @doc.css(".wsdescription").text.strip
    end

    def http_method
      @doc.css("#wsdescriptor").text.include?("HTTP POST request") ? :post : :get
    end
  end
end
