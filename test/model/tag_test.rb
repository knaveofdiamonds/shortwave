require 'helper'

class TagTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @tag = Model::Tag.parse("<tag><name>disco</name></tag>")
    @tag.session = StubSession.new
  end

  test "can be parsed from xml" do
    parsed = Model::Tag.parse(xml("tag_search"))
    assert_equal 20, parsed.size
    assert_equal 75545, parsed.first.count
    assert_equal "disco", parsed.first.name
    assert_equal "www.last.fm/tag/disco", parsed.first.url
  end

  test "has similar tags" do
    expect_get "method=tag.getSimilar&tag=disco", :tag_similar
    assert @tag.similar.first.kind_of? Model::Tag
  end

  test "has artists" do
    expect_get "method=tag.getTopArtists&tag=disco", :tag_top_artists
    assert @tag.artists.first.kind_of? Model::Artist
  end

  test "has albums" do
    expect_get "method=tag.getTopAlbums&tag=disco", :tag_top_albums
    assert @tag.albums.first.kind_of? Model::Album
  end

  test "has tracks" do
    expect_get "method=tag.getTopTracks&tag=disco", :tag_top_tracks
    assert @tag.tracks.first.kind_of? Model::Track
  end
end
