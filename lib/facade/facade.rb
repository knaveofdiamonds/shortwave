require 'restclient'
require 'uri'

module Shortwave
  module Facade
    class Authentication
      def initialize(api_key, secret)
        @api_key, @secret = api_key, secret
      end

      def signature(params)
        Digest::MD5.hexdigest(params.map {|k,v| [k.to_s, v.to_s] }.sort_by {|a| a[0] }.flatten.join("") + @secret)
      end
    end



    class Remote
      def initialize(auth)
        @auth = auth
      end

      protected
      
      BASE_URI = "http://ws.audioscrobbler.com/2.0/"
      DISALLOWED = Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")

      def get(data)
        merge_authentication(data)
        uri = BASE_URI + "?" + data.map {|k,v| "#{k.to_s}=#{URI.escape(v, DISALLOWED)}"}.join("&")
        RestClient.get uri
      end

      def post(data)
        merge_authentication(data)
        RestClient.post BASE_URI, data
      end

      private

      def merge_authentication(data)
        data.merge! @auth
      end
    end
  end
end

require File.dirname(__FILE__) + '/lastfm'
