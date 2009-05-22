require 'helper'
require 'facade_builder'

include Shortwave::Facade::Build

class CompilerTest < Mini::Test::TestCase

  test "outputs a simple method with no arguments" do
    method = stub( :remote_name => "user.getLovedTracks", 
                   :name => :loved_tracks,
                   :description => "Returns a user's loved tracks")

    expected = ["# Returns a user's loved tracks",
                "def loved_tracks",
                "end"]

    assert_equal expected, Compiler.new.compile(method)
  end

end
