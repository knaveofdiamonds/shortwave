require 'helper'
require 'facade/build/facade_builder'

include Shortwave::Facade::Build

RemoteMethodStub = Struct.new(:remote_name, :name, :description, :sample_response, :parameters, :http_method)
ParameterStub    = Struct.new(:name, :description, :required)

class ParameterStub
  def required?
    required
  end
end

class RubyMethodTest < TestCase

  test "outputs a simple method signature with no arguments" do
    method = RemoteMethodStub.new("user.getLovedTracks", :loved_tracks)
    assert_equal "loved_tracks", RubyMethod.new(method).signature
  end

  test "outputs the description as first line of comment" do
    method = RemoteMethodStub.new("user.getLovedTracks", :loved_tracks, "A user's loved tracks")
    assert_equal "# A user's loved tracks", RubyMethod.new(method).comment.first
  end

  test "outputs parameter descriptions as a comment" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  "Description",
                                  nil,
                                  [ParameterStub.new(:user, "A username", true),
                                   ParameterStub.new(:optional, "Optional", false),
                                   ParameterStub.new(:api_key, "api key", true)])

    expected = ["# Description",
                "#",
                "# +user+:: A username",
                "#",
                "# <b>Options</b>",
                "# +optional+:: Optional"]
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
    
    expected = ["get(:standard, {:method => \"user.getLovedTracks\", :user => user})"]
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

    expected = ["get(:standard, {:method => \"user.getLovedTracks\", :user => user}.merge(options))"]
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

    assert_equal "post", RubyMethod.new(method).body.first[0..3]
  end

  test "method with an sk parameter should be a session method" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:sk, "sk", true)],
                                  :get)
    expected = ["get(:session, {:method => \"user.getLovedTracks\"})"]
    assert_equal expected, RubyMethod.new(method).body
  end

  test "method with an api_sig but no sk parameter should be a signed method" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:api_sig, "api_sig", true)],
                                  :get)
    expected = ["get(:signed, {:method => \"user.getLovedTracks\"})"]
    assert_equal expected, RubyMethod.new(method).body
  end
end
