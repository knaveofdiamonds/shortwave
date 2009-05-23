require 'helper'
require 'facade/build/facade_builder'

class FacadeBuilderTest < TestCase
  
  test "remote method definitions can be loaded from file" do
    expected = {"User" => {"foo.bar" => "/baz"}}
    assert_equal( expected, FacadeBuilder.new.remote_method_definitions(File.dirname(__FILE__) + "/data/intro.yml") )
  end

  test "remote method defintions can be added to file" do
    expected = {"A" => {"B" => "C"}}

    File.expects(:exists?).returns(false)
    DocumentationRemote.expects(:scrape_remote_method_index).returns(expected)
    fh = mock()
    fh.expects(:write).with("--- \nA: \n  B: C\n")
    File.expects(:open).yields(fh)
    
    assert_equal( expected, FacadeBuilder.new.remote_method_definitions("non-existent") )
  end

end
