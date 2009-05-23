require 'restclient'
require 'uri'

module Shortwave
  module Facade

    class Remote
      def initialize(auth)
        @auth = auth
      end

      protected
      
      BASE_URI = "http://ws.audioscrobbler.com/2.0/"
      DISALLOWED = Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")

      def get(data)
        uri = BASE_URI + "?" + data.map {|k,v| "#{k.to_s}=#{URI.escape(v, DISALLOWED)}"}.join("&")
        RestClient.get uri
      end

      def post(data)
        RestClient.post BASE_URI, data
      end
    end

  end
end

require File.dirname(__FILE__) + '/lastfm'
