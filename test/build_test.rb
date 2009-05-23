require 'helper'
require 'facade_builder'
require 'fakeweb'

#FakeWeb.allow_net_connect = false

include Shortwave::Facade::Build

class BuildTest < Mini::Test::TestCase

  test "finds all remote methods from the intro page" do
    FakeWeb.register_uri :get, "http://last.fm/api/intro", :string => screen("intro_truncated")

    expected = {
      "album.addTags" => "/api/show/?service=302",
      "tasteometer.compare" => "/api/show/?service=258",
      "user.getLovedTracks" => "/api/show/?service=329",
      "venue.search" => "/api/show/?service=396"}

    assert_equal expected, DocumentationRemote.scrape_remote_method_uris
  end

#   test "build method follows links and builds RubyClasses" do
#     FakeWeb.register_uri :get, "http://last.fm/api/intro", :string => screen("intro_truncated")
#     FakeWeb.register_uri :get, "http://last.fm/api/show/?service=302", :string => screen("album_addTags")
#     FakeWeb.register_uri :get, "http://last.fm/api/show/?service=258", :string => screen("tasteometer_compare")
#     FakeWeb.register_uri :get, "http://last.fm/api/show/?service=329", :string => screen("user_getLovedTracks")
#     FakeWeb.register_uri :get, "http://last.fm/api/show/?service=396", :string => screen("venue_search")

#     result = DocumentationRemote.new.build("/api/intro")
#     assert_equal 4, result.size
#     assert_equal "Album", result.first.name
#     assert_equal 1, result.first.methods.size
#   end

#   test "build copes with HTTP error responses" do
#     FakeWeb.register_uri :get, "http://last.fm/api/intro", :string => screen("intro_truncated")
#     FakeWeb.register_uri :get, "http://last.fm/api/show/?service=302", :string => "Not found", :status => ["404", "Not found"]
#     FakeWeb.register_uri :get, "http://last.fm/api/show/?service=258", :string => screen("tasteometer_compare")
#     FakeWeb.register_uri :get, "http://last.fm/api/show/?service=329", :string => screen("user_getLovedTracks")
#     FakeWeb.register_uri :get, "http://last.fm/api/show/?service=396", :string => screen("venue_search")

#     result = DocumentationRemote.new.build("/api/intro")
#     assert_equal 0, result.first.methods.size
#   end

  private

  def screen(screen)
    File.read(File.dirname(__FILE__) + "/data/screens/#{screen}.html")
  end
end
