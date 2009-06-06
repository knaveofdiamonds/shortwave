require 'restclient'
require 'uri'
require 'forwardable'

module Shortwave
  module Facade
    # Wraps a RestClient::RequestFailed exception, and delegates +message+, +http_code+
    # and +response+ to the wrapped exception.
    #
    # This class is mainly provided for api stability in case we switch from using RestClient.
    class RemoteError < RuntimeError
      extend Forwardable
      def_delegators :cause, :message, :to_s, :http_code, :response

      def initialize(cause)
        @cause = cause
      end
    end

    # Base class for each remote facade.
    #
    # Remote methods may raise a RemoteError if an http error response is returned from
    # the Last.fm service.
    class Remote
      attr_reader :session

      # Creates a new facade, given a user session
      def initialize(session)
        @session = session
      end

      protected
      
      BASE_URI = "http://ws.audioscrobbler.com/2.0/"
      DISALLOWED = Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")

      def get(type, data)
        @session.merge!(type, data)
        uri = BASE_URI + "?" + data.map {|k,v| "#{k.to_s}=#{URI.escape(v.to_s, DISALLOWED)}"}.join("&")
        RestClient.get uri
      rescue RestClient::RequestFailed => e
        raise RemoteError.new(e)
      end

      def post(type, data)
        @session.merge!(type, data)
        RestClient.post BASE_URI, data
      rescue RestClient::RequestFailed => e
        raise RemoteError.new(e)
      end
    end
  end
end
