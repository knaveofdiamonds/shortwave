require 'restclient'
require 'uri'
require 'forwardable'

module Shortwave
  # Includes thin wrapper classes around the Last.fm web services API.
  #
  # These classes map one-to-one to the Last.fm API, and are in fact generated from the
  # HTML documentation the Last.fm provide. They make no attempt to OOify or XMLify the
  # responses - the results of these methods are just the string responses from Last.fm.
  # As such, they are a suitable base for building a "real" API on top of, which is
  # what classes in Shortwave::Model do.
  #
  # The general use is:
  #
  #    # Create a session for your platform
  #    session = Shortwave::Authentication::Mobile.new("api_key", "app_secret")
  #    
  #    # Authenticate if necessary (if you want to use write methods)
  #    session.authenticate("user", "password")
  #
  #    # Create a facade, passing in the session
  #    facade = Shortwave::Facade::Artist.new(session)
  #
  #    # Call methods on the facade
  #    facade.top_tags("The feelies")
  #    # => returns <lfm status="ok"> ... etc.
  #
  # Required method parameters in the web api are real method parameters - if the method
  # has optional parameters, these appear in an options hash after all the required parameters.
  # You do not need to provide any authentication parameters (+api_key+, +api_sig+ & +sk+) - these
  # are merged in from the session for you automatically.
  #
  # If the request fails, the facade method will raise a RemoteError.
  #
  # Each of the facades has further documentation, taken directly from the Last.fm documentation
  # at http://last.fm/api
  module Facade
    # Wraps a RestClient::RequestFailed exception, and delegates +message+, +http_code+
    # and +response+ to the wrapped exception.
    #
    # This class is mainly provided for api stability in case we switch from using RestClient.
    class RemoteError < RuntimeError
      extend Forwardable
      def_delegators :@cause, :message, :to_s, :http_code, :response

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
      AGENT = "Shortwave 0.0.1 http://shortwave.rubyforge.org/"

      def get(type, data)
        @session.merge!(type, data)
        uri = BASE_URI + "?" + data.map {|k,v| "#{k.to_s}=#{URI.escape(v.to_s, DISALLOWED)}"}.join("&")
        RestClient.get uri, {"User-Agent" => AGENT}
      rescue RestClient::RequestFailed => e
        raise RemoteError.new(e)
      end

      def post(type, data)
        @session.merge!(type, data, {"User-Agent" => AGENT})
        RestClient.post BASE_URI, data
      rescue RestClient::RequestFailed => e
        raise RemoteError.new(e)
      end
    end
  end
end
