require 'helper'

class VenueTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @venue = Model::Venue.parse(xml("venue_search"), :single => true)
  end

  test "venue has a name" do
    assert_equal "Koko", @venue.name
  end

  test "venue has a url" do
    assert_equal "http://www.last.fm/venue/8777134", @venue.url
  end

  test "venue has a location" do
    assert @venue.location.kind_of?( Model::Location )
  end

  test "venue has an id" do
    assert_equal 8777134, @venue.id
  end
end
