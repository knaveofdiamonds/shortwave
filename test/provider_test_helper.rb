class StubSession
  include Provider::ProviderMethods

  def merge!(*args)
  end

  def signed_in?
    true
  end
end

module ProviderTestHelper
  def setup
    super
    @facade = mock()
    @facade.stubs(:session).returns(StubSession.new)
  end

  def xml(file)
    File.read(File.dirname(__FILE__) + "/model/data/#{file}.xml")
  end

  def expect_get( params, return_xml)
    url = "http://ws.audioscrobbler.com/2.0/?" + params
    FakeWeb.register_uri :get, url, :string => xml(return_xml)
  end
end
