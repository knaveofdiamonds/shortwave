require 'helper'
require 'facade_builder'

class ParameterTest < Mini::Test::TestCase

  test "parameters can be parsed from an html screen" do
    raw = File.read(File.dirname(__FILE__) + "/data/screens/user_getLovedTracks.html")
    parameters = Shortwave::Facade::Build::Parameter.parse(raw)
    assert_equal 2, parameters.size
  end

  test "parameters have a name" do
    raw = File.read(File.dirname(__FILE__) + "/data/screens/user_getLovedTracks.html")
    parameters = Shortwave::Facade::Build::Parameter.parse(raw)
    assert_equal :user, parameters.first.name
  end

end
