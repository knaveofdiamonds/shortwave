require 'helper'
include Shortwave::Facade

require 'digest/md5'

class RemoteTest < TestCase
  test "can construct a method signature, given a hash of parameters and a secret" do
    params = {:foo => "bar", :api_key => 123}
    expected = Digest::MD5.hexdigest("api_key123foobar789")
    assert_equal expected, signature(params, "789")
  end

  def signature(params, secret)
    Digest::MD5.hexdigest(params.map {|k,v| [k.to_s, v.to_s] }.sort_by {|a| a[0] }.flatten.join("") + secret)
  end
end
