require 'helper'

class EventTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @event = Model::Event.parse(xml("venue_events"), :single => true)
  end

  test "event has an id" do
    assert_equal 968618, @event.id
  end
end
