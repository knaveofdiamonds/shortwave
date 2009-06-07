require 'helper'

class ChartDatesTest < TestCase
  include ProviderTestHelper

  test "can be parsed" do
    dates = Model::ChartDates.parse(xml("tag_weekly_chart_list")).first
    assert_equal Time.local(2008, 5, 25, 13, 0, 0), dates.from
    assert_equal Time.local(2008, 6, 1, 13, 0, 0), dates.to
  end
end
