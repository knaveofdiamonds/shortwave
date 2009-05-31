require 'helper'

class VenueProviderTest < TestCase
  include ProviderTestHelper

  test "can search for a venue" do
    expect_get "method=venue.search&venue=Koko", :venue_search
    assert_equal 23, StubSession.new.venue.search("Koko").size
  end

  test "can search for a venue limited by country" do
    expect_get "method=venue.search&venue=Koko&country=gb", :venue_search
    assert_equal 23, StubSession.new.venue.search("Koko", :gb).size
  end
end
