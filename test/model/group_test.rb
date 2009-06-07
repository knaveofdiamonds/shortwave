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
    assert_equal 250, @group.album_chart.size
    assert @group.album_chart.first.kind_of? Model::Album
  end

  test "has artists" do
    expect_get "method=group.getWeeklyArtistChart&group=lrug", :group_weekly_artist_chart
    assert_equal 100, @group.artist_chart.size
    assert @group.artist_chart.first.kind_of? Model::Artist
  end

  test "has tracks" do
    expect_get "method=group.getWeeklyTrackChart&group=lrug", :group_weekly_track_chart
    assert_equal 100, @group.track_chart.size
    assert @group.track_chart.first.kind_of? Model::Track
  end

  test "has chart dates" do
    expect_get "method=group.getWeeklyChartList&group=lrug", :tag_weekly_chart_list
    assert_equal 53, @group.chart_dates.size
    assert_equal (Time.at(1243166400)..Time.at(1243771200)), @group.chart_dates.first
  end
end
