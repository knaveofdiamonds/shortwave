require 'helper'
include Shortwave

class TagTest < TestCase
  def setup
    @facade = mock()
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

  private
  
  def xml(file)
    File.read(File.dirname(__FILE__) + "/data/#{file}.xml")
  end
end
