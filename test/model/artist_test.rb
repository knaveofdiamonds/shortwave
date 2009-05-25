require 'helper'

class ArtistTest < TestCase
  include ProviderTestHelper

  test "has a name" do
    parsed = Model::Artist.parse(xml("artist_info"), :single => true)
    assert_equal "The Feelies", parsed.name
  end

  test "has a url" do
    parsed = Model::Artist.parse(xml("artist_info"), :single => true)
    assert_equal "http://www.last.fm/music/The+Feelies", parsed.url
  end

  test "has a musicbrainz id" do
    parsed = Model::Artist.parse(xml("artist_info"), :single => true)
    assert_equal "28c07254-aeae-42ad-beea-67f59c3c8baf", parsed.mbid
  end

  test "has listeners" do
    parsed = Model::Artist.parse(xml("artist_info"), :single => true)
    assert_equal 43593, parsed.listeners
  end

  test "has a play count" do
    parsed = Model::Artist.parse(xml("artist_info"), :single => true)
    assert_equal 498218, parsed.play_count
  end

  test "has a biography and summary" do
    parsed = Model::Artist.parse(xml("artist_info"), :single => true)
    assert parsed.biography
    assert parsed.biography_summary
  end
end
