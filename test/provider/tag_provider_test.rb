require 'helper'
include Shortwave

class TagProviderTest < TestCase
  def setup
    super
    @facade = mock()
    @provider = Provider::TagProvider.new(@facade)
  end


  test "can get a single tag" do
    xml = File.read(File.dirname(__FILE__) + "/../model/data/tag_search.xml")
    @facade.expects(:search).with("disco").returns(xml)
    assert_equal "disco", @provider.get("disco").name
  end

  test "can build a tag from attributes" do
    assert_equal "disco", @provider.build(:name => "disco").name
  end
end
