class StubSession
  include Provider::ProviderMethods
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
end
