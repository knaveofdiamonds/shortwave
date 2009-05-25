require 'helper'
include Shortwave

class StubSession
  include Provider::ProviderMethods
end

class ArtistProviderTest < TestCase
  def setup
    super
    @facade = mock()
    @facade.stubs(:session).returns(StubSession.new)
    @provider = Provider::ArtistProvider.new(@facade)
  end

  test "can get an artist by name" do
    xml = File.read(File.dirname(__FILE__) + "/../model/data/artist_info.xml")
    @facade.expects(:info).with(:artist => "The Feelies").returns(xml)
    assert_equal "The Feelies", @provider.get("The Feelies").name
  end

  test "can get an artist by mbid" do
    xml = File.read(File.dirname(__FILE__) + "/../model/data/artist_info.xml")
    @facade.expects(:info).with(:mbid => "28c07254-aeae-42ad-beea-67f59c3c8baf").returns(xml)
    assert_equal "The Feelies", @provider.get("28c07254-aeae-42ad-beea-67f59c3c8baf").name
  end
end
