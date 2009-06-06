require 'helper'

class GroupProviderTest < TestCase
  include ProviderTestHelper

  test "can build a group" do
    assert StubSession.new.group.build(:name => "mnml").kind_of?(Shortwave::Model::Group)
  end
end
