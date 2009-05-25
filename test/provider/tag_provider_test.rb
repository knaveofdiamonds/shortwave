require 'helper'
include Shortwave

class StubSession
  include Provider::ProviderMethods
end

class TagProviderTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @provider = Provider::TagProvider.new(@facade)
  end

  test "can get a single tag" do
    @facade.expects(:search).with("disco").returns(xml("tag_search"))
    assert_equal "disco", @provider.get("disco").name
  end

  test "can build a tag from attributes" do
    assert_equal "disco", @provider.build(:name => "disco").name
  end

  test "can get most popular tags" do
    @facade.expects(:top_tags).returns(xml("tag_top_tags"))
    assert_equal 250, @provider.popular.size
  end
end
