require 'helper'
require 'facade_builder'

include Shortwave::Facade::Build

RemoteMethodStub = Struct.new(:remote_name, :name, :description, :sample_response, :parameters, :http_method)
ParameterStub    = Struct.new(:name, :description, :required)

class ParameterStub
  def required?
    required
  end
end

class RubyMethodTest < Mini::Test::TestCase

  test "outputs a simple method signature with no arguments" do
    method = RemoteMethodStub.new("user.getLovedTracks", :loved_tracks)
    assert_equal "loved_tracks", RubyMethod.new(method).signature
  end

  test "outputs the description as first line of comment" do
    method = RemoteMethodStub.new("user.getLovedTracks", :loved_tracks, "A user's loved tracks")
    assert_equal "# A user's loved tracks", RubyMethod.new(method).comment.first
  end

  test "outputs the sample response as a comment, if present" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  "Returns a user's loved tracks",
                                  "<lfm status=\"ok\">\n</lfm>" )

    expected = ["# Returns a user's loved tracks",
                "#",
                "# Sample response:",
                "#",
                "# <lfm status=\"ok\">",
                "# </lfm>"]

    assert_equal expected, RubyMethod.new(method).comment
  end

  test "adds required parameters to the method signature" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:user, "A username", true)])

    assert_equal "loved_tracks(user)", RubyMethod.new(method).signature
  end

  [:api_key, :api_sig, :sk].each do |param|
    test "#{param} parameter should not be part of the signature" do
      method = RemoteMethodStub.new("user.getLovedTracks", 
                                    :loved_tracks,
                                    nil,
                                    nil,
                                    [ParameterStub.new(:user, "A username", true),
                                     ParameterStub.new(param, "API key", true)])

      assert_equal "loved_tracks(user)", RubyMethod.new(method).signature
    end
  end

  test "optional parameters should be collapsed to an options hash" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:user, "A username", true),
                                   ParameterStub.new(:number, "optional", false)])

    assert_equal "loved_tracks(user, options={})", RubyMethod.new(method).signature
  end

  test "method body generates a GET request to the remote method" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:user, "A username", true)],
                                  :get)
    
    expected = ["data = {:method => \"user.getLovedTracks\", :user => user}.merge(@auth)",
                "get \"\", data"]

    assert_equal expected, RubyMethod.new(method).body
  end

  test "optional parameters are merged into the sent data" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:user, "A username", true),
                                   ParameterStub.new(:number, "optional", false)],
                                  :get)

    expected = ["data = {:method => \"user.getLovedTracks\", :user => user}.merge(@auth).merge(options)",
                "get \"\", data"]
    assert_equal expected, RubyMethod.new(method).body
  end

  test "write methods are sent via POST" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:user, "A username", true),
                                   ParameterStub.new(:number, "optional", false)],
                                  :post)

    assert_equal "post \"\", data", RubyMethod.new(method).body.last
  end
end
