require 'helper'
include Shortwave
include Digest

class AuthenticationTest < TestCase
  def setup
    @auth = Authentication::Session.new("123", "789")
  end

  test "can construct a method signature, given a hash of parameters and a secret" do
    params = {:foo => "bar", :api_key => 123}
    assert_equal MD5.hexdigest("api_key123foobar789"), @auth.signature(params)
  end

  test "merges in the api key to the parameters if user authentication is not required" do
    assert_equal( {:foo => "bar", :api_key => "123"}, @auth.merge!(:standard, :foo => "bar")  )
  end

  test "raises Authentication error unless session_key is set" do
    assert_raise(Authentication::NotAuthenticated) { @auth.merge!(:session, {}) }
  end
end

class MobileAuthenticationTest < TestCase
  test "mobile session calls through to Last.fm api" do
    FakeWeb.register_uri :get, "http://ws.audioscrobbler.com/2.0/?username=bob&method=auth.getMobileSession&authToken=4ea54fb6bc6cda12c4eff51263c21cd4&api_key=123&api_sig=bff4f0a37a6e2b99e36542f41eadecde", :string => '<lfm status="ok">\n<session><name>bob</name><key>456</key><subscriber>0</subscriber></session>\n</lfm>'

    @auth = Authentication::Mobile.new("123", "789")
    @auth.authenticate("bob", "secret")
    assert @auth.signed_in?
    assert_equal "456", @auth.session_key
  end
end

class DesktopTest < TestCase
  test "provides a uri for the user to sign in at" do
    FakeWeb.register_uri :get, "http://ws.audioscrobbler.com/2.0/?method=auth.getToken&api_key=123&api_sig=bedb3b5ac843c821d2812f4de3922d7a", :string => '<lfm status="ok">\n<token>456</token>\n</lfm>'

    @auth = Authentication::Desktop.new("123", "789")
    assert_equal "http://www.last.fm/api/auth/?api_key=123&token=456", @auth.uri
  end
end

class WebTest < TestCase
  test "provides a uri for the user to sign in at" do
    @auth = Authentication::Web.new("123", "789")
    assert_equal "http://www.last.fm/api/auth/?api_key=123", @auth.uri
  end

  test "can authenticate" do
    FakeWeb.register_uri :get, "http://ws.audioscrobbler.com/2.0/?method=auth.getSession&api_key=123&token=456&api_sig=0510662b73e1af4edbd9b8f8fc66b04f", :string => '<lfm status="ok">\n<session><name>bob</name><key>456</key><subscriber>0</subscriber></session>\n</lfm>'
    @auth = Authentication::Web.new("123", "789")
    @auth.authenticate("456")
    assert_equal "456", @auth.session_key
  end
end
