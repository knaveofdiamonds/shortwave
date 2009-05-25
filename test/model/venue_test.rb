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
end
