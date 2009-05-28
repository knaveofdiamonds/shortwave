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

  test "can search for albums by name" do
    @facade.expects(:search).with("Only Life").returns(xml("album_search"))
    assert_equal 20, @provider.search("Only Life").size
  end

end
