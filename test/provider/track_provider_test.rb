require 'helper'

class TrackProviderTest < TestCase
  include ProviderTestHelper

  test "can get a track by artist & track name" do
    expect_get "method=track.getInfo&artist=Led%20Zeppelin&track=Stairway%20to%20Heaven", :track_info
    assert StubSession.new.track.get("Led Zeppelin", "Stairway to Heaven").kind_of?(Shortwave::Model::Track)
  end

  test "can get a track by mbid" do
    expect_get "method=track.getInfo&mbid=464efacc-a133-4ae6-a9ff-7573c448eb32", :track_info
    assert StubSession.new.track.get_by_id("464efacc-a133-4ae6-a9ff-7573c448eb32").kind_of?(Shortwave::Model::Track)
  end

  test "can get a track by musicbrainz mbid model" do
    mbid = stub(:uuid => "464efacc-a133-4ae6-a9ff-7573c448eb32")
    expect_get "method=track.getInfo&mbid=464efacc-a133-4ae6-a9ff-7573c448eb32", :track_info
    assert StubSession.new.track.get_by_id(mbid).kind_of?(Shortwave::Model::Track)
  end

  test "can search for a track" do
    expect_get "method=track.search&track=Stairway%20to%20heaven", :track_search
    assert 20, StubSession.new.track.search("Stairway to heaven").size
  end
end
