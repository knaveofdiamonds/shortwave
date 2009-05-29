require 'helper'

class TrackTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @facade.stubs(:session).returns(stub(:track_facade => @facade))
    @track = Model::Track.parse(xml("track_info"), :single => true)
    @track.session = @facade.session
  end

  test "has a name" do
    assert_equal "Stairway to Heaven", @track.name
  end

  test "has an id" do
    assert_equal 12729, @track.id
  end

  test "has listeners" do
    assert_equal 514346, @track.listeners
  end

  test "has a url" do
    assert_equal "http://www.last.fm/music/Led+Zeppelin/_/Stairway+to+Heaven", @track.url
  end

  test "has a play count" do
    assert_equal 3438976, @track.play_count
  end

  test "can be streamable" do
    assert @track.streamable?
  end

  test "has a duration in milliseconds" do
    assert_equal 478000, @track.duration
  end

  test "has an artist" do
    assert_equal "Led Zeppelin", @track.artist.name
  end

  test "has an album" do
    assert_equal "Led Zeppelin IV", @track.album.name
  end

  test "has tags" do
    @facade.expects(:tags).with("Led Zeppelin", "Stairway to Heaven").returns(xml("tag_search"))
    @track.tags
  end
end
