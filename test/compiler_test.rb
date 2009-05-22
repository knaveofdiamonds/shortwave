require 'helper'
require 'facade_builder'

include Shortwave::Facade::Build

class CompilerTest < Mini::Test::TestCase

  test "outputs a simple method with no arguments" do
    method = stub( :remote_name => "user.getLovedTracks", 
                   :name => :loved_tracks )

    assert_equal ["def loved_tracks", "end"], Compiler.new.compile(method)
  end

end
