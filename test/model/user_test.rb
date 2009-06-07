require 'helper'

class UserTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @user = Model::User.parse(xml("user_info"), :single => true)
    @user.session = StubSession.new
  end

  test "has a name" do
    assert_equal "knaveofdiamonds", @user.name
  end

  test "has an id" do
    assert_equal 7532711, @user.id
  end

  test "has a real name" do
    assert_equal "Roland Swingler", @user.real_name
  end

  test "has a url" do
    assert_equal "http://www.last.fm/user/knaveofdiamonds", @user.url
  end

  test "has an image" do
    assert_equal "http://userserve-ak.last.fm/serve/126/10636291.jpg", @user.image
  end

  test "has a language" do
    assert_equal "en", @user.language
  end

  test "has a country" do
    assert_equal "UK", @user.country
  end

  test "can be a subscriber" do
    assert_equal false, @user.subscriber
  end

  test "has a play count" do
    assert_equal 8251, @user.play_count
  end

  test "has album chart" do
    expect_get "method=user.getWeeklyAlbumChart&user=knaveofdiamonds", :group_weekly_album_chart
    assert_equal 250, @user.album_chart.size
  end

  test "has artist chart" do
    expect_get "method=user.getWeeklyArtistChart&user=knaveofdiamonds", :group_weekly_artist_chart
    assert_equal 100, @user.artist_chart.size
  end

  test "has track chart" do
    expect_get "method=user.getWeeklyTrackChart&user=knaveofdiamonds", :group_weekly_track_chart
    assert_equal 100, @user.track_chart.size
  end

  test "has chart dates" do
    expect_get "method=user.getWeeklyChartList&user=knaveofdiamonds", :tag_weekly_chart_list
    assert_equal 53, @user.chart_dates.size
  end

  test "has events" do
    expect_get "method=user.getEvents&user=knaveofdiamonds", :venue_events
    assert @user.events.first.kind_of? Model::Event
  end

  test "has past events" do
    expect_get "method=user.getPastEvents&user=knaveofdiamonds", :venue_events
    assert @user.past_events.first.kind_of? Model::Event
  end

  test "has recent tracks" do
    expect_get "method=user.getRecentTracks&user=knaveofdiamonds", :user_recent_tracks
    assert @user.recent_tracks.first.kind_of? Model::Track
  end

  test "has neighbours" do
    expect_get "method=user.getNeighbours&user=knaveofdiamonds", :user_neighbours
    assert @user.neighbours.first.kind_of? Model::User
  end

  test "has friends" do
    expect_get "method=user.getFriends&user=knaveofdiamonds", :user_neighbours
    assert @user.friends.first.kind_of? Model::User
  end

  test "has loved tracks" do
    expect_get "method=user.getLovedTracks&user=knaveofdiamonds", :track_search
    assert @user.loved_tracks.first.kind_of? Model::Track
  end

  test "has playlists" do
    expect_get "method=user.getPlaylists&user=knaveofdiamonds", :user_playlists
    assert @user.playlists.first.kind_of? Model::Playlist
  end

  test "has shouts" do
    expect_get "method=user.getShouts&user=knaveofdiamonds", :user_shouts
    assert @user.shouts.first.kind_of? Model::Shout
  end

  # Logged in user only

  test "has recommended events" do
    expect_get "method=user.getRecommendedEvents", :venue_events
    assert @user.recommended_events.first.kind_of? Model::Event
  end

  test "has recommended artists" do
    expect_get "method=user.getRecommendedArtists", :user_recommended_artists
    assert @user.recommended_artists.first.kind_of? Model::Artist
  end
end
