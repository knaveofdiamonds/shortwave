require 'helper'
require 'facade_builder'

class FacadeBuilderSimpleTest < Mini::Test::TestCase
  def setup
    raw = File.read(File.dirname(__FILE__) + "/data/screens/user_getLovedTracks.html")
    @builder = Shortwave::FacadeBuilder.new(raw)
  end

  test "parsed method has a description" do
    assert_equal "Get the last 50 tracks loved by a user.", @builder.description
  end

  test "parsed method has a remote name" do
    assert_equal "user.getLovedTracks", @builder.remote_name
  end

  test "parsed method has a name" do
    assert_equal :loved_tracks, @builder.name
  end

  test "parsed method has parameters" do
    assert_equal [:user, :api_key], @builder.parameters
  end

  test "read methods should use http GET" do
    assert_equal :get, @builder.http_method
  end

  test "write methods should use http POST" do
    raw = File.read(File.dirname(__FILE__) + "/data/screens/album_addTags.html")
    builder = Shortwave::FacadeBuilder.new(raw)
    assert_equal :post, builder.http_method
  end
end
