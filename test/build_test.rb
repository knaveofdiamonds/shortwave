require 'helper'
require 'facade_builder'
require 'fakeweb'

FakeWeb.allow_net_connect = false
include Shortwave::Facade::Build

class BuildTest < TestCase

  test "finds all remote methods from the intro page" do
    FakeWeb.register_uri :get, "http://last.fm/api/intro", :string => screen("intro_truncated")
    expected = {
      "Album" => {"album.addTags" => "/api/show/?service=302"},
      "Tasteometer" => {"tasteometer.compare" => "/api/show/?service=258"},
      "User" => {"user.getLovedTracks" => "/api/show/?service=329"},
      "Venue" => {"venue.search" => "/api/show/?service=396"}
    }

    assert_equal expected, DocumentationRemote.scrape_remote_method_index
  end

  private

  def screen(screen)
    File.read(File.dirname(__FILE__) + "/data/screens/#{screen}.html")
  end
end
