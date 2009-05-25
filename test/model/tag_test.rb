require 'helper'
include Shortwave

class TagTest < TestCase
  test "can be parsed from xml" do
    xml = File.read(File.dirname(__FILE__) + "/data/tag_search.xml")
    parsed = Model::Tag.parse(xml)
    assert_equal 20, parsed.size
    assert_equal 75545, parsed.first.count
    assert_equal "disco", parsed.first.name
    assert_equal "www.last.fm/tag/disco", parsed.first.url
  end
end
