require 'helper'

class PlaylistTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @playlist = Model::Playlist.parse(xml("user_playlists"), :single => true)
  end
  
  test "has id" do
    assert_equal 1011557, @playlist.id
  end

  test "has a title" do
    assert_equal "knaveofdiamonds\342\200\231s playlist", @playlist.title
  end

  test "has a description" do
    assert_equal "a description", @playlist.description
  end

  test "has a creation time" do
    assert_equal Time.local(2007, 8, 23, 22, 4, 33), @playlist.created_at
  end

  test "has a size" do
    assert_equal 27, @playlist.size
  end

  test "has a total duration" do
    assert_equal 7487, @playlist.duration
  end

  test "can be streamable" do
    assert ! @playlist.streamable?
  end

  test "has a url" do
    assert_equal "http://www.last.fm/user/knaveofdiamonds/library/playlists/loit_knaveofdiamonds%25E2%2580%2599s_playlist", @playlist.url
  end

  test "can have tracks added to it" do
    @facade.stubs(:session => stub(:playlist_facade => @facade))
    @playlist.session = @facade.session
    @facade.expects(:add_track).with(1011557, "Title", "Artist").returns(xml("ok"))
    track = stub(:name => "Title", :artist_name => "Artist")

    @playlist.add_track(track)
  end
end
