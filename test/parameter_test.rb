require 'helper'
require 'facade/build/facade_builder'

class ParameterTest < TestCase

  test "can be parsed from an html screen" do
    assert_equal 2, make_parameters("user_getLovedTracks").size
  end

  test "have a name" do
    assert_equal :user, make_parameters("user_getLovedTracks").first.name
  end

  test "can be required or optional" do
    assert make_parameters("venue_search").first.required?
    assert ! make_parameters("venue_search")[1].required?
  end

  test "can have a description" do
    assert_equal "The venue name you would like to search for.", 
      make_parameters("venue_search").first.description
  end

  test "copes with defaults in the optional section" do
    assert ! make_parameters("tasteometer_compare")[4].required?
  end

  test "copes with multiple parameters defined as type[1|2]" do
    assert_equal :type1, make_parameters("tasteometer_compare").first.name
    assert_equal :type2, make_parameters("tasteometer_compare")[1].name
  end

  test "copes with extra information in the required string" do
    assert make_parameters("tasteometer_compare").first.required?
  end

  private

  def make_parameters(screen)
    raw = File.read(File.dirname(__FILE__) + "/data/screens/#{screen}.html")
    Shortwave::Facade::Build::Parameter.parse(raw)
  end
end
