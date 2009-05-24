require 'nokogiri'
require 'digest/md5'
include Digest

module Shortwave
  module Authentication
    class NotAuthorised < StandardError
    end

    class Base
      attr_reader :session_key
      
      def initialize(api_key, secret)
        @api_key, @secret = api_key, secret
        @session_key = nil
        @facade = Facade::Auth.new(self)
      end

      def signed_in?
        ! @session_key.nil?
      end

      def merge!(type, params)
        raise NotAuthorised.new("Requires authentication!") if type == :session && @session_key.nil?

        params.merge!(:api_key => @api_key)
        params.merge!(:sk => @session_key) if type == :session
        params.merge!(:api_sig => signature(params)) if type == :session || type == :signed
        params
      end

      def signature(params)
        sorted_params = params.map {|k,v| [k.to_s, v.to_s] }.sort_by {|a| a[0] }
        MD5.hexdigest(sorted_params.flatten.join("") + @secret)
      end

      protected

      def parse_session_response(response)
        @session_key = Nokogiri::XML(response).css("key").text.strip
      end
    end

    # Get a mobile session
    class Mobile < Base
      def authenticate(username, password)
        response = @facade.mobile_session(username, MD5.hexdigest(username + MD5.hexdigest(password)))
        parse_session_response(response)
      end
    end

    class Web < Base
      # The uri you should direct users to in their web browser, so they can authenticate. If successful,
      # the callback url defined in your api account will be called, with a token parameter. Pass this
      # token to the authenticate method.
      def uri
        "http://www.last.fm/api/auth/?api_key=#{@api_key}"
      end

      def authenticate(token)
        parse_session_response(@facade.session(token))
      end
    end

    class Desktop < Base
      def uri
        response = @facade.token
        @token = Nokogiri::XML(response).css("token").text.strip
        "http://www.last.fm/api/auth/?api_key=#{@api_key}&token=#{@token}"
      end

      def authenticate
        parse_session_response(@facade.session(token))
      end
    end
  end
end
