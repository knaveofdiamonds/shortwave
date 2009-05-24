require 'helper'
include Shortwave::Facade

require 'digest/md5'

class AuthenticationTest < TestCase
  test "can construct a method signature, given a hash of parameters and a secret" do
    params = {:foo => "bar", :api_key => 123}
    expected = Digest::MD5.hexdigest("api_key123foobar789")
    assert_equal expected, Authentication.new("123", "789").signature(params)
  end
end
