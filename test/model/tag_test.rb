require 'helper'

class TagTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @facade.stubs(:session).returns(stub(:tag_facade => @facade))
    @provider = Provider::TagProvider.new(@facade)
  end

  test "can be parsed from xml" do
    parsed = Model::Tag.parse(xml("tag_search"))
    assert_equal 20, parsed.size
    assert_equal 75545, parsed.first.count
    assert_equal "disco", parsed.first.name
    assert_equal "www.last.fm/tag/disco", parsed.first.url
  end

  test "has similar tags" do
    @facade.expects(:similar).with("disco").returns(xml("tag_similar"))
    similar = @provider.build(:name => "disco").similar

    assert_equal 50, similar.size
    assert_equal "italo disco", similar.first.name
    assert_equal true, similar.first.streamable
  end
end
