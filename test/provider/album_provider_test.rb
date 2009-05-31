require 'helper'

class AlbumProviderTest < TestCase
  include ProviderTestHelper

  test "can get an album by artist and name" do
    expect_get "method=album.getInfo&artist=The%20Feelies&album=Only%20Life", :album_info
    assert_equal "Only Life", StubSession.new.album.get_by_name("The Feelies", "Only Life").name
  end

  test "can get an album by musicbrainz id" do
    expect_get "method=album.getInfo&mbid=464efacc-a133-4ae6-a9ff-7573c448eb32", :album_info
    assert_equal "Only Life", StubSession.new.album.get("464efacc-a133-4ae6-a9ff-7573c448eb32").name
  end

  test "can get an album by RBrainz mbid model" do
    expect_get "method=album.getInfo&mbid=464efacc-a133-4ae6-a9ff-7573c448eb32", :album_info
    assert_equal "Only Life", StubSession.new.album.get(stub(:uuid => "464efacc-a133-4ae6-a9ff-7573c448eb32")).name
  end

  test "can search for albums by name" do
    expect_get "method=album.search&album=Only%20Life", :album_search
    assert_equal 20, StubSession.new.album.search("Only Life").size
  end

end
