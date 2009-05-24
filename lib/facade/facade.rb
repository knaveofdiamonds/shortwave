require 'restclient'
require 'uri'
require 'digest/md5'
include Digest

module Shortwave
  module Facade
    class AuthenticationError < StandardError
    end

    class Authentication
      def initialize(api_key, secret)
        @api_key, @secret = api_key, secret
        @session_key = nil
      end

      def signed_in?
        ! @session_key.nil?
      end

      def merge!(type, params)
        raise AuthenticationError.new("Requires authentication!") if type == :session && @session_key.nil?

        params.merge!(:api_key => @api_key)
        params.merge!(:sk => @session_key) if type == :session
        params.merge!(:api_sig => signature(params)) if type == :session || type == :signed
        params
      end

      def signature(params)
        sorted_params = params.map {|k,v| [k.to_s, v.to_s] }.sort_by {|a| a[0] }
        MD5.hexdigest(sorted_params.flatten.join("") + @secret)
      end
    end


    class MobileAuthentication < Authentication
      def authenticate(username, password)
        # FIXME - actually extract the session key
        @session_key = Auth.new(self).mobile_session(username, MD5.hexdigest(username + MD5.hexdigest(password)))
      end
    end


    class Remote
      def initialize(auth)
        @auth = auth
      end

      protected
      
      BASE_URI = "http://ws.audioscrobbler.com/2.0/"
      DISALLOWED = Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")

      def get(type, data)
        @auth.merge!(type, data)
        uri = BASE_URI + "?" + data.map {|k,v| "#{k.to_s}=#{URI.escape(v, DISALLOWED)}"}.join("&")
        RestClient.get uri
      end

      def post(type, data)
        @auth.merge!(type, data)
        RestClient.post BASE_URI, data
      end
    end
  end
end

require File.dirname(__FILE__) + '/lastfm'
