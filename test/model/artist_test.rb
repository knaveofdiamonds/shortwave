require 'helper'

class ArtistTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @facade.stubs(:session).returns(stub(:artist_facade => @facade))
    @artist = Model::Artist.parse(xml("artist_info"), :single => true)
    @artist.session = @facade.session
  end

  test "has a name" do
    assert_equal "The Feelies", @artist.name
  end

  test "has a url" do
    assert_equal "http://www.last.fm/music/The+Feelies", @artist.url
  end

  test "has a musicbrainz id" do
    assert_equal "28c07254-aeae-42ad-beea-67f59c3c8baf", @artist.mbid
  end

  test "has listeners" do
    assert_equal 43593, @artist.listeners
  end

  test "has a play count" do
    assert_equal 498218, @artist.play_count
  end

  test "has a biography and summary" do
    assert @artist.biography
    assert @artist.biography_summary
  end

  test "has images" do
    assert_equal 3, @artist.images.size
  end

  test "has user tags" do
    @facade.expects(:tags).with("The Feelies").returns(xml("tag_search"))
    @artist.my_tags
  end

  test "has shouts" do
    @facade.expects(:shouts).with("The Feelies").returns(xml("artist_shouts"))
    assert_equal 104, @artist.shouts.size
  end

  test "can be shouted at" do
    @facade.expects(:shout).with("The Feelies", "Hi there").returns(xml("ok"))
    @artist.shout("Hi there")
  end

  test "can be shared with other users or email addresses" do
    args = ["The Feelies", "roland@example.com,kate", {:message => "This is awesome!"}]
    @facade.expects(:share).with(*args).returns(xml("ok"))
    # TODO should be a user object, not just a username
    @artist.share(["roland@example.com", "kate"], "This is awesome!")
  end

  test "has events" do
    @artist.session = StubSession.new
    expect_get "method=artist.getEvents&artist=The%20Feelies", :venue_events
    assert @artist.events.first.kind_of? Model::Event
  end

  test "has similar artists" do
    @artist.session = StubSession.new
    expect_get "method=artist.getSimilar&artist=The%20Feelies", :artist_search
    assert @artist.similar.first.kind_of? Model::Artist
  end

  test "has albums" do
    @artist.session = StubSession.new
    expect_get "method=artist.getTopAlbums&artist=The%20Feelies", :album_search
    assert @artist.albums.first.kind_of? Model::Album
  end

  test "has fans" do
    @artist.session = StubSession.new
    expect_get "method=artist.getTopFans&artist=The%20Feelies", :artist_top_fans
    assert @artist.fans.first.kind_of? Model::User
  end

  test "has tags" do
    @artist.session = StubSession.new
    expect_get "method=artist.getTopTags&artist=The%20Feelies", :tag_search
    assert @artist.tags.first.kind_of? Model::Tag
  end

  test "has tracks" do
    @artist.session = StubSession.new
    expect_get "method=artist.getTopTracks&artist=The%20Feelies", :track_search
    assert @artist.tracks.first.kind_of? Model::Track
  end
end
