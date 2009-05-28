require 'helper'

class AlbumTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @album = Model::Album.parse(xml("album_info"), :single => true)
  end

  test "has a name" do
    assert_equal "Only Life", @album.name
  end

  test "has an id" do
    assert_equal 2045356, @album.id
  end

  test "has a url" do
    assert_equal "http://www.last.fm/music/The+Feelies/Only+Life", @album.url
  end

  test "has a release date" do
    assert_equal Time.local(1987, 11, 30, 0, 0, 0), @album.release_date
  end

  test "has images" do
    assert_equal 4, @album.images.size
  end

  test "has a musicbrainz id" do
    assert_equal "464efacc-a133-4ae6-a9ff-7573c448eb32", @album.mbid
  end

  test "has listeners" do
    assert_equal 10068, @album.listeners
  end

  test "has a play count" do
    assert_equal 67545, @album.play_count
  end

  test "has tags" do
    assert_equal 5, @album.tags.size
  end

  test "has an artist name" do
    assert_equal "The Feelies", @album.artist_name
  end
end
