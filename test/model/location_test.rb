require 'helper'

class LocationTest < Test::Unit::TestCase
  include ProviderTestHelper

  def setup
    super
    @location = StubSession.new.location.build(:country => "United Kingdom", :city => "London")
  end

  test "has artists" do
    expect_get "method=geo.getTopArtists&country=United%20Kingdom", :artist_search
    assert @location.artists.first.kind_of? Model::Artist
  end

  test "has tracks" do
    expect_get "method=geo.getTopTracks&country=United%20Kingdom&location=London", :track_search
    assert @location.tracks.first.kind_of? Model::Track
  end

  test "has events" do
    expect_get "method=geo.getEvents&location=London", :location_events
    assert @location.events.first.kind_of? Model::Event
  end
end
