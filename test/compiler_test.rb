require 'helper'
require 'facade_builder'

include Shortwave::Facade::Build

RemoteMethodStub = Struct.new(:remote_name, :name, :description, :sample_response, :parameters)
ParameterStub    = Struct.new(:name, :description, :required)

class ParameterStub
  def required?
    required
  end
end

class CompilerTest < Mini::Test::TestCase

  test "outputs a simple method signature with no arguments" do
    method = RemoteMethodStub.new("user.getLovedTracks", :loved_tracks)
    assert_equal "loved_tracks", Compiler.new.compile(method).signature
  end

  test "outputs the description as first line of comment" do
    method = RemoteMethodStub.new("user.getLovedTracks", :loved_tracks, "A user's loved tracks")
    assert_equal "# A user's loved tracks", Compiler.new.compile(method).comment.first
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

    assert_equal expected, Compiler.new.compile(method).comment
  end

  test "adds required parameters to the method signature" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:user, "A username", true)])

    assert_equal "loved_tracks(user)", Compiler.new.compile(method).signature
  end

  [:api_key, :api_sig, :sk].each do |param|
    test "#{param} parameter should not be part of the signature" do
      method = RemoteMethodStub.new("user.getLovedTracks", 
                                    :loved_tracks,
                                    nil,
                                    nil,
                                    [ParameterStub.new(:user, "A username", true),
                                     ParameterStub.new(param, "API key", true)])

      assert_equal "loved_tracks(user)", Compiler.new.compile(method).signature
    end
  end

  test "optional parameters should be collapsed to an options hash" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:user, "A username", true),
                                   ParameterStub.new(:number, "optional", false)])

    assert_equal "loved_tracks(user, options={})", Compiler.new.compile(method).signature
  end

  test "method body generates a GET request to the remote method" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:user, "A username", true)])
    
    expected = ["data = {:method => \"user.getLovedTracks\", :user => user}.merge(@auth)",
                "get \"\", data"]

    assert_equal expected, Compiler.new.compile(method).body
  end

  test "optional parameters are merged into the sent data" do
    method = RemoteMethodStub.new("user.getLovedTracks", 
                                  :loved_tracks,
                                  nil,
                                  nil,
                                  [ParameterStub.new(:user, "A username", true),
                                   ParameterStub.new(:number, "optional", false)])

    expected = ["data = {:method => \"user.getLovedTracks\", :user => user}.merge(@auth).merge(options)",
                "get \"\", data"]
    assert_equal expected, Compiler.new.compile(method).body
  end
end
