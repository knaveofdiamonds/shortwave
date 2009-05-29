require 'helper'

class TrackProviderTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @provider = Provider::TrackProvider.new(@facade)
  end

  test "can get a track by artist & track name" do
    @facade.expects(:info).with(:artist => "Led Zeppelin", :track => "Stairway to Heaven").returns(xml("track_info"))
    assert @provider.get_by_name("Led Zeppelin", "Stairway to Heaven").kind_of?(Shortwave::Model::Track)
  end

  test "can get a track by mbid" do
    @facade.expects(:info).with(:mbid => "464efacc-a133-4ae6-a9ff-7573c448eb32").returns(xml("track_info"))
    assert @provider.get("464efacc-a133-4ae6-a9ff-7573c448eb32").kind_of?(Shortwave::Model::Track)
  end

  test "can get a track by musicbrainz mbid model" do
    @facade.expects(:info).with(:mbid => "464efacc-a133-4ae6-a9ff-7573c448eb32").returns(xml("track_info"))
    assert @provider.get(stub(:uuid => "464efacc-a133-4ae6-a9ff-7573c448eb32")).kind_of?(Shortwave::Model::Track)
  end
end
