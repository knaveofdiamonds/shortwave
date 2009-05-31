require 'helper'

class UserProviderTest < TestCase
  include ProviderTestHelper

  test "can provide the logged in user" do
    expect_get "method=user.getInfo", :user_info
    assert_equal "Roland Swingler", StubSession.new.user.logged_in_user.real_name
  end
end

