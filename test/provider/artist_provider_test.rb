require 'helper'

class ArtistProviderTest < TestCase
  include ProviderTestHelper

  test "can get an artist by name" do
    expect_get "method=artist.getInfo&artist=The%20Feelies", :artist_info
    assert_equal "The Feelies", StubSession.new.artist.get("The Feelies").name
  end

  test "can get an artist by mbid" do
    expect_get "method=artist.getInfo&mbid=28c07254-aeae-42ad-beea-67f59c3c8baf", :artist_info
    assert_equal "The Feelies", StubSession.new.artist.get("28c07254-aeae-42ad-beea-67f59c3c8baf").name
  end

  test "can get an artist by an Rbrainz MBID model via uuid attribute" do
    expect_get "method=artist.getInfo&mbid=28c07254-aeae-42ad-beea-67f59c3c8baf", :artist_info
    assert_equal "The Feelies", StubSession.new.artist.get(stub(:uuid => "28c07254-aeae-42ad-beea-67f59c3c8baf")).name
  end

  test "can search for artists by name" do
    expect_get "method=artist.search&artist=The%20Feelies", :artist_search
    assert_equal 11, StubSession.new.artist.search("The Feelies").size
  end
end
