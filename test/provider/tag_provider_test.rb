require 'helper'

class TagProviderTest < TestCase
  include ProviderTestHelper

  test "can get a single tag" do
    expect_get "method=tag.search&tag=disco", :tag_search
    assert_equal "disco", StubSession.new.tag.get("disco").name
  end

  test "can build a tag from attributes" do
    assert_equal "disco", StubSession.new.tag.build(:name => "disco").name
  end

  test "can get most popular tags" do
    expect_get "method=tag.getTopTags", :tag_top_tags
    assert_equal 250, StubSession.new.tag.popular.size
  end

  test "can search for a tag" do
    expect_get "method=tag.search&tag=disco", :tag_search
    assert_equal 20, StubSession.new.tag.search("disco").size
  end
end
