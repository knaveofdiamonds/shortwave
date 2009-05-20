require 'helper'
require 'nokogiri'

class FacadeBuilderTest < Mini::Test::TestCase
  test "parsed method has a description" do
    raw = File.read(File.dirname(__FILE__) + "/data/screens/user_getLovedTracks.html")
    assert_equal "Get the last 50 tracks loved by a user.", find_description(raw)
  end

  def find_description(html)
    doc = Nokogiri::HTML(html)
    doc.css(".wsdescription").text.strip
  end
end
