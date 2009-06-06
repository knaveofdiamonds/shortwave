require 'helper'

class GroupTest < TestCase
  include ProviderTestHelper

  def setup
    super
    session = StubSession.new
    @group = session.group.build(:name => "lrug")
  end

  test "has a name" do
    assert_equal "lrug", @group.name
  end

  test "has members" do
    expect_get "method=group.getMembers&group=lrug", :group_members
    assert_equal 34, @group.members.size
    assert @group.members.first.kind_of? Model::User
  end

  test "has albums" do
    expect_get "method=group.getWeeklyAlbumChart&group=lrug", :group_weekly_album_chart
    assert_equal 250, @group.albums.size
    assert @group.albums.first.kind_of? Model::Album
  end

  test "has artists" do
    expect_get "method=group.getWeeklyArtistChart&group=lrug", :group_weekly_artist_chart
    assert_equal 100, @group.artists.size
    assert @group.artists.first.kind_of? Model::Artist
  end

  test "has tracks" do
    expect_get "method=group.getWeeklyTrackChart&group=lrug", :group_weekly_track_chart
    assert_equal 100, @group.tracks.size
    assert @group.tracks.first.kind_of? Model::Track
  end
end
