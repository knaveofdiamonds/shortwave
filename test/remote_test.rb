require 'helper'

include Shortwave::Facade

class RemoteTest < TestCase
  def setup
    FakeWeb.clean_registry
    @auth = mock()
    @auth.expects(:merge!)
  end

  test "get methods include data" do
    FakeWeb.register_uri :get, "http://ws.audioscrobbler.com/2.0/?foo=bar", :string => "ok"
    data = Remote.new(@auth).send(:get, :standard, {:foo => "bar"})
    assert_equal "ok", data
  end

  test "parameters are uri escaped correctly" do
    FakeWeb.register_uri :get, "http://ws.audioscrobbler.com/2.0/?foo=bar%26baz%20ok", :string => "ok"
    data = Remote.new(@auth).send(:get, :standard, {:foo => "bar&baz ok"})
    assert_equal "ok", data
  end
end
