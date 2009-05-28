require 'helper'

class ArtistProviderTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @provider = Provider::ArtistProvider.new(@facade)
  end

  test "can get an artist by name" do
    @facade.expects(:info).with(:artist => "The Feelies").returns(xml("artist_info"))
    assert_equal "The Feelies", @provider.get("The Feelies").name
  end

  test "can get an artist by mbid" do
    @facade.expects(:info).with(:mbid => "28c07254-aeae-42ad-beea-67f59c3c8baf").returns(xml("artist_info"))
    assert_equal "The Feelies", @provider.get("28c07254-aeae-42ad-beea-67f59c3c8baf").name
  end

  test "can search for artists by name" do
    @facade.expects(:search).with("The Feelies").returns(xml("artist_search"))
    assert_equal 11, @provider.search("The Feelies").size
  end
end
