require 'digest/md5'
include Digest

module Shortwave
  module Authentication
    class NotAuthorised < StandardError
    end

    class Base
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
    end

    # Get a mobile session
    class Mobile < Base
      def authenticate(username, password)
        # FIXME - actually extract the session key
        @session_key = @facade.mobile_session(username, MD5.hexdigest(username + MD5.hexdigest(password)))
      end
    end
  end
end
