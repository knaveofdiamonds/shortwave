require 'helper'
require 'facade_builder'
require 'fakeweb'

#FakeWeb.allow_net_connect = false

include Shortwave::Facade::Build

class BuildTest < Mini::Test::TestCase

  test "finds all remote methods from the intro page" do
    raw = File.read(File.dirname(__FILE__) + "/data/screens/intro_truncated.html")
    expected = {
      "Album" => ["/api/show/?service=302"],
      "Tasteometer" => ["/api/show/?service=258"],
      "User" => ["/api/show/?service=329"],
      "Venue" => ["/api/show/?service=396"]}

    assert_equal expected, scrape_remote_methods(raw)
  end

  test "build method follows links and builds RubyClasses" do
    FakeWeb.register_uri "http://last.fm/api/intro", :string => screen("intro_truncated")
    FakeWeb.register_uri "http://last.fm/api/show/?service=302", :string => screen("album_addTags")
    FakeWeb.register_uri "http://last.fm/api/show/?service=258", :string => screen("tasteometer_compare")
    FakeWeb.register_uri "http://last.fm/api/show/?service=329", :string => screen("user_getLovedTracks")
    FakeWeb.register_uri "http://last.fm/api/show/?service=396", :string => screen("venue_search")

    result = build("/api/intro")
    assert_equal 4, result.size
    assert_equal "Album", result.first.name
    assert_equal 1, result.first.methods.size
  end

  private

  def screen(screen)
    File.read(File.dirname(__FILE__) + "/data/screens/#{screen}.html")
  end
end
