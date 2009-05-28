require 'nokogiri'
require 'digest/md5'
include Digest

module Shortwave
  # Authentication classes.
  module Authentication
    # Indicates that you have tried to call a remote method that require authentication,
    # but have not authenticated yet.
    class NotAuthenticated < StandardError
    end

    # Base functionality for session-based authentication mechanisms. Don't use this
    # directly - use one of its subclasses: Web, Desktop or Mobile.
    class Session
      include Provider::ProviderMethods

      attr_reader :session_key
      
      # Creates a new authneticator with your api account key and secret.
      def initialize(api_key, secret, session_key=nil)
        @api_key, @secret, @session_key = api_key, secret, session_key
        @facade = Facade::Auth.new(self)
      end

      # Is the user signed in to Last.fm?
      def signed_in?
        ! @session_key.nil?
      end
      
      # Merges relevant authentication details with method parameters.
      def merge!(type, params)
        raise NotAuthenticated.new("Requires authentication!") if type == :session && @session_key.nil?

        params.merge!(:api_key => @api_key)
        params.merge!(:sk => @session_key) if type == :session
        params.merge!(:api_sig => signature(params)) if type == :session || type == :signed
        params
      end

      # Generates a method signature for method parameters.
      def signature(params)
        sorted_params = params.map {|k,v| [k.to_s, v.to_s] }.sort_by {|a| a[0] }
        MD5.hexdigest(sorted_params.flatten.join("") + @secret)
      end

      protected

      # Parses the response to Auth.getSession
      def parse_session_response(response)
        doc = Nokogiri::XML(response)
        if doc.root['status'] = 'ok'
          @session_key = doc.css("key").text.strip 
        else
          raise doc.css("error").text
        end
      end
    end

    # Authentication for mobile applications. Don't use this for web/desktop applications
    # use either Authentication::Web or Authentication::Desktop instead
    class Mobile < Session
      # Authenticates with a user's username and password
      def authenticate(username, password)
        response = @facade.mobile_session(username, MD5.hexdigest(username + MD5.hexdigest(password)))
        parse_session_response(response)
      end
    end

    # Authentication for web applications. Send your user to the page given by +uri+
    # and use the token provided to your callback url as an argument to +authenticate+
    class Web < Session
      # The uri you should direct users to in their web browser, so they can authenticate. If successful,
      # the callback url defined in your api account will be called, with a token parameter. Pass this
      # token to the authenticate method.
      def uri
        "http://www.last.fm/api/auth/?api_key=#{@api_key}"
      end

      # Gets an authenticated session key. Call after the user has logged in at +uri+ with the
      # token returned to your callback uri.
      def authenticate(token)
        parse_session_response(@facade.session(token))
      end
    end

    # Authentication for destop applications. Send your user to the page given by +uri+
    # and then call +authenticate+.
    class Desktop < Session
      # A uri the user should log in at.
      def uri
        response = @facade.token
        @token = Nokogiri::XML(response).css("token").text.strip
        "http://www.last.fm/api/auth/?api_key=#{@api_key}&token=#{@token}"
      end

      # Gets an authenticated session key. Call after the user has logged in at +uri+.
      def authenticate
        parse_session_response(@facade.session(token))
      end
    end
  end
end
