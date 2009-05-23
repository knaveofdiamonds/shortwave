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

  def scrape_remote_methods(html)
    Nokogiri::HTML(html).css("li.package").inject({}) do |hsh, node|
      hsh[node.text] = node.next.next.css("a").map {|a| a['href'] }
      hsh
    end
  end
end
