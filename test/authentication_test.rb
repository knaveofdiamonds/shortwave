require 'helper'
include Shortwave::Facade
include Digest

class AuthenticationTest < TestCase
  def setup
    @auth = Authentication.new("123", "789")
  end

  test "can construct a method signature, given a hash of parameters and a secret" do
    params = {:foo => "bar", :api_key => 123}
    assert_equal MD5.hexdigest("api_key123foobar789"), @auth.signature(params)
  end

  test "merges in the api key to the parameters if user authentication is not required" do
    assert_equal( {:foo => "bar", :api_key => "123"}, @auth.merge!(:foo => "bar")  )
  end
end
