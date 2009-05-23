require 'helper'

include Shortwave::Facade

class RemoteTest < TestCase
  def setup
    FakeWeb.clean_registry
  end

  test "get methods include data" do
    FakeWeb.register_uri :get, "http://ws.audioscrobbler.com/2.0/?foo=bar", :string => "ok"
    data = Remote.new({}).send(:get, {:foo => "bar"})
    assert_equal "ok", data
  end

  test "parameters are uri escaped correctly" do
    FakeWeb.register_uri :get, "http://ws.audioscrobbler.com/2.0/?foo=bar%26baz%20ok", :string => "ok"
    data = Remote.new({}).send(:get, {:foo => "bar&baz ok"})
    assert_equal "ok", data
  end

  test "merges the api_key from the authentication object" do
    FakeWeb.register_uri :get, "http://ws.audioscrobbler.com/2.0/?api_key=123&foo=bar", :string => "ok"
    data = Remote.new({:api_key => "123"}).send(:get, {:foo => "bar"})
    assert_equal "ok", data
  end
end
