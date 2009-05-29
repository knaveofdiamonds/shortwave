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

  test "has an id" do
    assert_equal 7532711, @user.id
  end

  test "has a real name" do
    assert_equal "Roland Swingler", @user.real_name
  end

  test "has a url" do
    assert_equal "http://www.last.fm/user/knaveofdiamonds", @user.url
  end

  test "has an image" do
    assert_equal "http://userserve-ak.last.fm/serve/126/10636291.jpg", @user.image
  end

  test "has a language" do
    assert_equal "en", @user.language
  end

  test "has a country" do
    assert_equal "UK", @user.country
  end

  test "can be a subscriber" do
    assert_equal false, @user.subscriber
  end

  test "has a play count" do
    assert_equal 8251, @user.play_count
  end
end
