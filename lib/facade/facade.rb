require 'restclient'
require 'uri'
require 'digest/md5'

module Shortwave
  module Facade
    class AuthenticationError < StandardError
    end

    class Authentication
      def initialize(api_key, secret)
        @api_key, @secret = api_key, secret
      end

      def merge!(params, requires_user_auth=false)
        if requires_user_auth
          raise AuthenticationError.new("Requires authentication!") unless @session_key
        else
          params.merge!(:api_key => @api_key)
        end
      end

      def signature(params)
        sorted_params = params.map {|k,v| [k.to_s, v.to_s] }.sort_by {|a| a[0] }
        Digest::MD5.hexdigest(sorted_params.flatten.join("") + @secret)
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
        @auth.merge!(data)
        uri = BASE_URI + "?" + data.map {|k,v| "#{k.to_s}=#{URI.escape(v, DISALLOWED)}"}.join("&")
        RestClient.get uri
      end

      def post(data)
        @auth.merge!(data)
        RestClient.post BASE_URI, data
      end
    end
  end
end

require File.dirname(__FILE__) + '/lastfm'
