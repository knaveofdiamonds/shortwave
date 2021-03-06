require 'helper'

class EventTest < TestCase
  include ProviderTestHelper

  def setup
    super
    @event = Model::Event.parse(xml("venue_events"), :single => true)
  end

  test "has an id" do
    assert_equal 968618, @event.id
  end

  test "has an url" do
    assert_equal "http://www.last.fm/event/968618", @event.url
  end

  test "has an attendance count" do
    assert_equal 55, @event.attendance_count
  end

  test "has a description" do
    assert_equal "", @event.description
  end

  test "has a start time" do
    assert_equal Time.local(2009, 6, 1, 19, 30, 0), @event.starts_at
  end

  test "has a name" do
    assert_equal "Phoenix", @event.name
  end

  test "has a review count" do
    assert_equal 0, @event.review_count
  end

  test "has artists" do
    @event.session = StubSession.new
    artists = @event.artists
    assert_equal 2, @event.artists_raw.size
    assert_equal "Phoenix", @event.artists.first.name
  end

  test "has a headliner" do
    @event.session = StubSession.new
    assert_equal "Phoenix", @event.headliner.name
  end

  test "has attendees" do
    @event.session = StubSession.new
    expect_get "method=event.getAttendees&event=968618", :artist_top_fans
    assert @event.attendees.first.kind_of? Model::User
  end

  test "can be attended by the session user" do
    @facade.stubs(:session => stub(:event_facade => @facade))
    @event.session = @facade.session
    @facade.expects(:attend).with(968618, 0)
    @event.attend
  end
end
