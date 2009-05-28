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
end
