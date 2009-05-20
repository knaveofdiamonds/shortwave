require 'helper'
require 'facade_builder'

class FacadeBuilderTest < Mini::Test::TestCase
  def setup
    raw = File.read(File.dirname(__FILE__) + "/data/screens/user_getLovedTracks.html")
    @builder = Shortwave::FacadeBuilder.new(raw)
  end

  test "parsed method has a description" do
    assert_equal "Get the last 50 tracks loved by a user.", @builder.description
  end

  test "parsed method has a name" do
    assert_equal "user.getLovedTracks", @builder.name
  end

  test "parsed method has parameters" do
    assert_equal [:user, :api_key], @builder.parameters
  end
end
