require 'helper'

class ComparisonTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @comparison = Model::Comparison.parse(xml("tasteometer_compare"), :single => true)
  end

  test "has a score" do
    assert_equal 0.71107162951922, @comparison.score
  end

  test "has artists" do
    assert_equal 4, @comparison.artists.size
  end
end
