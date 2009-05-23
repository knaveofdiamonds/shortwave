require 'httparty'

module Shortwave
  module Facade

    class Remote
      include HTTParty
      base_uri "http://ws.audioscrobbler.com/2.0/"
    end

  end
end

require File.dirname(__FILE__) + '/lastfm'
