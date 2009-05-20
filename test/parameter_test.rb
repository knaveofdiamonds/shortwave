require 'helper'
require 'facade_builder'

class ParameterTest < Mini::Test::TestCase

  test "can be parsed from an html screen" do
    raw = File.read(File.dirname(__FILE__) + "/data/screens/user_getLovedTracks.html")
    parameters = Shortwave::Facade::Build::Parameter.parse(raw)
    assert_equal 2, parameters.size
  end

  test "have a name" do
    raw = File.read(File.dirname(__FILE__) + "/data/screens/user_getLovedTracks.html")
    parameters = Shortwave::Facade::Build::Parameter.parse(raw)
    assert_equal :user, parameters.first.name
  end

  test "can be required or optional" do
    raw = File.read(File.dirname(__FILE__) + "/data/screens/venue_search.html")
    parameters = Shortwave::Facade::Build::Parameter.parse(raw)
    assert parameters.first.required?
    assert ! parameters[1].required?
  end

end
