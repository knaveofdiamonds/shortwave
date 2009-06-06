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
end
