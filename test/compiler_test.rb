require 'helper'
require 'facade_builder'

include Shortwave::Facade::Build

class CompilerTest < Mini::Test::TestCase

  test "outputs a simple method with no arguments" do
    method = stub( :remote_name => "user.getLovedTracks", 
                   :name => :loved_tracks,
                   :description => "Returns a user's loved tracks",
                   :sample_response => nil )

    expected = ["# Returns a user's loved tracks",
                "def loved_tracks",
                "end"]

    assert_equal expected, Compiler.new.compile(method)
  end

  test "outputs the sample response as a comment, if present" do
    method = stub( :remote_name => "user.getLovedTracks", 
                   :name => :loved_tracks,
                   :description => "Returns a user's loved tracks",
                   :sample_response => "<lfm status=\"ok\">\n</lfm>" )
    expected = ["# Returns a user's loved tracks",
                "#",
                "# Sample response:",
                "#",
                "# <lfm status=\"ok\">",
                "# </lfm>"]
    assert_equal expected, Compiler.new.compile(method)[0..5]
  end

end
