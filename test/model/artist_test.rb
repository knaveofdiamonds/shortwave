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

  test "has tags" do
    @facade.expects(:tags).with("The Feelies").returns([])
    @artist.tags
  end

  test "has shouts" do
    @facade.expects(:shouts).with("The Feelies").returns(xml("artist_shouts"))
    assert_equal 104, @artist.shouts.size
  end

  test "can be shouted at" do
    @facade.expects(:shout).with("The Feelies", "Hi there").returns(xml("ok"))
    @artist.shout("Hi there")
  end
end
