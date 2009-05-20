require 'helper'
require 'nokogiri'

class FacadeBuilderTest < Mini::Test::TestCase
  
  def setup
    @raw = File.read(File.dirname(__FILE__) + "/data/screens/user_getLovedTracks.html")
  end

  test "parsed method has a description" do
    assert_equal "Get the last 50 tracks loved by a user.", find_description(@raw)
  end

  test "parsed method has a name" do
    assert_equal "user.getLovedTracks", find_name(@raw)
  end

  test "parsed method has parameters" do
    assert_equal [:user, :api_key], find_parameters(@raw)
  end

  def find_parameters(html)
    Nokogiri::HTML(html).css("#wsdescriptor h2 ~ .param").map {|node| node.text.strip.to_sym }
  end

  def find_name(html)
    Nokogiri::HTML(html).css("#wstitle ~ h1").text.strip
  end

  def find_description(html)
    Nokogiri::HTML(html).css(".wsdescription").text.strip
  end
end
