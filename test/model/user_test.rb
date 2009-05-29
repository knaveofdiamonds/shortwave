require 'helper'

class UserTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @facade.stubs(:session).returns(stub(:user_facade => @facade))
    @user = Model::User.parse(xml("user_info"), :single => true)
    @user.session = @facade.session
  end

  test "has a name" do
    assert_equal "knaveofdiamonds", @user.name
  end
end
