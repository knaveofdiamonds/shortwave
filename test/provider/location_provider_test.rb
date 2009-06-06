require 'helper'

class LocationProviderTest < TestCase
  include ProviderTestHelper

  test "can build a location" do
    assert StubSession.new.location.build(:city => "london").kind_of?(Shortwave::Model::Location)
  end
end
