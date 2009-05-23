require 'helper'

include Shortwave::Facade

class RemoteTest < TestCase

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
end
