require 'helper'
require 'facade_builder'
require 'fakeweb'

#FakeWeb.allow_net_connect = false

include Shortwave::Facade::Build

class BuildTest < Mini::Test::TestCase

  test "finds all remote methods from the intro page" do
    raw = File.read(File.dirname(__FILE__) + "/data/screens/intro_truncated.html")
    doc = Nokogiri::HTML(raw)
    expected = {
      "Album" => ["/api/show/?service=302"],
      "Tasteometer" => ["/api/show/?service=258"],
      "User" => ["/api/show/?service=329"],
      "Venue" => ["/api/show/?service=396"]}

    result = doc.css("li.package").inject({}) do |hsh, node|
      hsh[node.text] = node.next.next.css("a").map {|a| a['href'] }
      hsh
    end

    assert_equal expected, result
  end  
end
