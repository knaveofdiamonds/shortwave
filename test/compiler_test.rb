require 'helper'
require 'facade_builder'

include Shortwave::Facade::Build

RemoteMethodStub = Struct.new(:remote_name, :name, :description, :sample_response)
class CompilerTest < Mini::Test::TestCase

  test "outputs a simple method with no arguments" do
    method = RemoteMethodStub.new("user.getLovedTracks", :loved_tracks, "Returns a user's loved tracks")

    expected = ["# Returns a user's loved tracks",
                "def loved_tracks",
                "end"]

    assert_equal expected, Compiler.new.compile(method)
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

    assert_equal expected, Compiler.new.compile(method)[0..5]
  end

end
