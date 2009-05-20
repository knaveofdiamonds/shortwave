require 'helper'
require 'facade_builder'

class FacadeBuilderSimpleTest < Mini::Test::TestCase

  test "parsed method has a description" do
    make_builder "user_getLovedTracks"
    assert_equal "Get the last 50 tracks loved by a user.", @method.description
  end

  test "parsed method has a remote name" do
    make_builder "user_getLovedTracks"
    assert_equal "user.getLovedTracks", @method.remote_name
  end

  test "parsed method has a name" do
    make_builder "user_getLovedTracks"
    assert_equal :loved_tracks, @method.name
  end

  test "parsed method has parameters" do
    make_builder "user_getLovedTracks"
    assert_equal [:user, :api_key], @method.parameters
  end

  test "read methods should use http GET" do
    make_builder "user_getLovedTracks"
    assert_equal :get, @method.http_method
  end

  test "write methods should use http POST" do
    make_builder "album_addTags"
    assert_equal :post, @method.http_method
  end

  test "parsed methods have sample response code" do
    make_builder "album_addTags"
    assert_equal "<lfm status=\"ok\">\n</lfm>", @method.sample_response
  end

  private

  def make_builder(screen)
    raw = File.read(File.dirname(__FILE__) + "/data/screens/#{screen}.html")
    @method = Shortwave::Facade::Build::RemoteMethod.new(raw)
  end
end
