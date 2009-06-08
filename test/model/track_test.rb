require 'helper'

class TrackTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @track = Model::Track.parse(xml("track_info"), :single => true)
    @track.session = StubSession.new
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

  test "has user tags" do
    expect_get "method=track.getTags&artist=Led%20Zeppelin&track=Stairway%20to%20Heaven", :tag_search
    assert @track.my_tags.first.kind_of? Model::Tag
  end

  test "has similar tracks" do
    expect_get "method=track.getSimilar&track=Stairway%20to%20Heaven&artist=Led%20Zeppelin", :track_search
    assert @track.similar.first.kind_of? Model::Track
  end

  test "has fans" do
    expect_get "method=track.getTopFans&track=Stairway%20to%20Heaven&artist=Led%20Zeppelin", :artist_top_fans
    assert @track.fans.first.kind_of? Model::User
  end

  test "has tags" do
    expect_get "method=track.getTopTags&track=Stairway%20to%20Heaven&artist=Led%20Zeppelin", :tag_similar
    assert @track.tags.first.kind_of? Model::Tag
  end
end
