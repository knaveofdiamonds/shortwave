require 'helper'

class ShoutTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @shout = Model::Shout.parse(xml("artist_shouts"), :single => true)
    @shout.session = StubSession.new
  end

  test "has a body" do
    assert @shout.body
  end

  test "has a time" do
    assert_equal Time.local(2009, 5, 13, 3, 58, 30), @shout.time
  end

  test "has an author" do
    assert_equal "distantfingers", @shout.user.name
  end
end
