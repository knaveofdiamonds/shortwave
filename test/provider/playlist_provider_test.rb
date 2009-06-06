require 'helper'

class PlaylistProviderTest < Test::Unit::TestCase
  include ProviderTestHelper

  test "can create a playlist for a user" do
    f = Facade::Playlist.new(stub())
    # Ugly, but fakeweb can't cope with post yet
    f.expects(:post).with(:session, :title => "test", :description => "foo", :method => "playlist.create").returns(xml(:playlist_fetch))
    assert Provider::PlaylistProvider.new(f).create("test", "foo").kind_of?(Shortwave::Model::Playlist)
  end
end
