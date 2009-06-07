require 'helper'

class VenueTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @venue = Model::Venue.parse(xml("venue_search"), :single => true)
    @venue.session = StubSession.new
  end

  test "venue has a name" do
    assert_equal "Koko", @venue.name
  end

  test "venue has a city" do
    assert_equal "London", @venue.city
  end

  test "venue has a country" do
    assert_equal "United Kingdom", @venue.country
  end

  test "venue has a street address" do
    assert_equal "1a Camden High Street, Camden", @venue.street_address
  end

  test "venue has a post code" do
    assert_equal "NW1 7JE", @venue.postcode
  end

  test "venue has a url" do
    assert_equal "http://www.last.fm/venue/8777134", @venue.url
  end

  test "venue has a location" do
    assert_in_delta 51.53469, @venue.location.latitude, 0.000001
    assert_in_delta -0.138434, @venue.location.longitude, 0.000001
  end

  test "venue's location has session set" do
    @venue.session = stub()
    assert @venue.instance_variable_get("@session".to_sym)
    assert @venue.location.instance_variable_get("@session".to_sym)
  end

  test "venue has an id" do
    assert_equal 8777134, @venue.id
  end

  test "has events" do
    expect_get "method=venue.getEvents&venue=8777134", :venue_events
    assert @venue.events.first.kind_of? Model::Event
  end

  test "has past events" do
    expect_get "method=venue.getPastEvents&venue=8777134", :venue_events
    assert @venue.past_events.first.kind_of? Model::Event
  end
end
