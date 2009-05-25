require 'helper'
include Shortwave

class TagProviderTest < TestCase

  test "can get a single tag" do
    xml = File.read(File.dirname(__FILE__) + "/../model/data/tag_search.xml")
    facade = mock()
    facade.expects(:search).with("disco").returns(xml)
    provider = Provider::TagProvider.new(facade)
    assert_equal "disco", provider.get("disco").name
  end

  test "can build a tag from attributes" do
    facade = mock()
    provider = Provider::TagProvider.new(facade)
    assert_equal "disco", provider.build(:name => "disco").name
  end
end
