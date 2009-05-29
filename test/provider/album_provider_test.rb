require 'helper'

class AlbumProviderTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @provider = Provider::AlbumProvider.new(@facade)
  end

  test "can get an album by artist and name" do
    @facade.expects(:info).with(:artist => "The Feelies", :album => "Only Life").returns(xml("album_info"))
    assert_equal "Only Life", @provider.get_by_name("The Feelies", "Only Life").name
  end

  test "can get an album by musicbrainz id" do
    @facade.expects(:info).with(:mbid => "464efacc-a133-4ae6-a9ff-7573c448eb32").returns(xml("album_info"))
    assert_equal "Only Life", @provider.get("464efacc-a133-4ae6-a9ff-7573c448eb32").name
  end

  test "can get an album by RBrainz mbid model" do
    @facade.expects(:info).with(:mbid => "464efacc-a133-4ae6-a9ff-7573c448eb32").returns(xml("album_info"))
    assert_equal "Only Life", @provider.get(stub(:uuid => "464efacc-a133-4ae6-a9ff-7573c448eb32")).name
  end

  test "can search for albums by name" do
    @facade.expects(:search).with("Only Life").returns(xml("album_search"))
    assert_equal 20, @provider.search("Only Life").size
  end

end
