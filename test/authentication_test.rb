require 'helper'
include Shortwave
include Digest

class AuthenticationTest < TestCase
  def setup
    @auth = Authentication::Base.new("123", "789")
  end

  test "can construct a method signature, given a hash of parameters and a secret" do
    params = {:foo => "bar", :api_key => 123}
    assert_equal MD5.hexdigest("api_key123foobar789"), @auth.signature(params)
  end

  test "merges in the api key to the parameters if user authentication is not required" do
    assert_equal( {:foo => "bar", :api_key => "123"}, @auth.merge!(:standard, :foo => "bar")  )
  end

  test "raises Authentication error unless session_key is set" do
    assert_raise(Authentication::NotAuthorised) { @auth.merge!(:session, {}) }
  end
end

class MobileAuthenticationTest < TestCase
  test "mobile session calls through to Last.fm api" do
    FakeWeb.register_uri :get, "http://ws.audioscrobbler.com/2.0/?username=bob&method=auth.getMobileSession&authToken=4ea54fb6bc6cda12c4eff51263c21cd4&api_key=123&api_sig=bff4f0a37a6e2b99e36542f41eadecde", :string => "ok"

    @auth = Authentication::Mobile.new("123", "789")
    @auth.authenticate("bob", "secret")
    assert @auth.signed_in?
  end
end
