require 'helper'
require 'facade_builder'

include Shortwave::Facade::Build

class RubyClassTest < Mini::Test::TestCase

  test "has a name" do
    assert_equal "User", RubyClass.new("User").name
  end

end
