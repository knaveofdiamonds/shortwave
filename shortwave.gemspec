# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{shortwave}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roland Swingler"]
  s.date = %q{2009-06-11}
  s.email = %q{roland.swingler@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     ".gitmodules",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/shortwave.rb",
     "lib/shortwave/authentication.rb",
     "lib/shortwave/facade.rb",
     "lib/shortwave/facade/build/facade_builder.rb",
     "lib/shortwave/facade/build/facade_template.erb",
     "lib/shortwave/facade/lastfm.rb",
     "lib/shortwave/facade/remote.rb",
     "lib/shortwave/model/album.rb",
     "lib/shortwave/model/artist.rb",
     "lib/shortwave/model/base_model.rb",
     "lib/shortwave/model/chart_dates.rb",
     "lib/shortwave/model/comparison.rb",
     "lib/shortwave/model/event.rb",
     "lib/shortwave/model/group.rb",
     "lib/shortwave/model/location.rb",
     "lib/shortwave/model/playlist.rb",
     "lib/shortwave/model/shout.rb",
     "lib/shortwave/model/tag.rb",
     "lib/shortwave/model/track.rb",
     "lib/shortwave/model/user.rb",
     "lib/shortwave/model/venue.rb",
     "lib/shortwave/model/weekly_charts.rb",
     "lib/shortwave/providers.rb",
     "shortwave.gemspec",
     "test/authentication_test.rb",
     "test/build/build_test.rb",
     "test/build/data/intro.yml",
     "test/build/data/screens/album_addTags.html",
     "test/build/data/screens/intro_truncated.html",
     "test/build/data/screens/tasteometer_compare.html",
     "test/build/data/screens/user_getLovedTracks.html",
     "test/build/data/screens/venue_search.html",
     "test/build/facade_builder_test.rb",
     "test/build/parameter_test.rb",
     "test/build/remote_method_test.rb",
     "test/build/ruby_class_test.rb",
     "test/build/ruby_method_test.rb",
     "test/helper.rb",
     "test/model/album_test.rb",
     "test/model/artist_test.rb",
     "test/model/chart_dates_test.rb",
     "test/model/comparison_test.rb",
     "test/model/data/album_info.xml",
     "test/model/data/album_search.xml",
     "test/model/data/artist_info.xml",
     "test/model/data/artist_search.xml",
     "test/model/data/artist_shouts.xml",
     "test/model/data/artist_top_fans.xml",
     "test/model/data/event_info.xml",
     "test/model/data/group_members.xml",
     "test/model/data/group_weekly_album_chart.xml",
     "test/model/data/group_weekly_artist_chart.xml",
     "test/model/data/group_weekly_track_chart.xml",
     "test/model/data/location_events.xml",
     "test/model/data/ok.xml",
     "test/model/data/playlist_fetch.xml",
     "test/model/data/tag_search.xml",
     "test/model/data/tag_similar.xml",
     "test/model/data/tag_top_albums.xml",
     "test/model/data/tag_top_artists.xml",
     "test/model/data/tag_top_tags.xml",
     "test/model/data/tag_top_tracks.xml",
     "test/model/data/tag_weekly_chart_list.xml",
     "test/model/data/tasteometer_compare.xml",
     "test/model/data/track_info.xml",
     "test/model/data/track_search.xml",
     "test/model/data/user_chartlist.xml",
     "test/model/data/user_info.xml",
     "test/model/data/user_neighbours.xml",
     "test/model/data/user_playlists.xml",
     "test/model/data/user_recent_tracks.xml",
     "test/model/data/user_recommended_artists.xml",
     "test/model/data/user_shouts.xml",
     "test/model/data/user_weekly_artist_chart.xml",
     "test/model/data/venue_events.xml",
     "test/model/data/venue_past_events.xml",
     "test/model/data/venue_search.xml",
     "test/model/event_test.rb",
     "test/model/group_test.rb",
     "test/model/location_test.rb",
     "test/model/playlist_test.rb",
     "test/model/shout_test.rb",
     "test/model/tag_test.rb",
     "test/model/track_test.rb",
     "test/model/user_test.rb",
     "test/model/venue_test.rb",
     "test/provider/album_provider_test.rb",
     "test/provider/artist_provider_test.rb",
     "test/provider/group_provider_test.rb",
     "test/provider/location_provider_test.rb",
     "test/provider/playlist_provider_test.rb",
     "test/provider/tag_provider_test.rb",
     "test/provider/track_provider_test.rb",
     "test/provider/user_provider_test.rb",
     "test/provider/venue_provider_test.rb",
     "test/provider_test_helper.rb",
     "test/remote_test.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://shortwave.rubyforge.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{shortwave}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{A Last.fm API wrapper}
  s.test_files = [
    "test/helper.rb",
     "test/model/location_test.rb",
     "test/model/tag_test.rb",
     "test/model/track_test.rb",
     "test/model/artist_test.rb",
     "test/model/album_test.rb",
     "test/model/playlist_test.rb",
     "test/model/venue_test.rb",
     "test/model/group_test.rb",
     "test/model/shout_test.rb",
     "test/model/user_test.rb",
     "test/model/chart_dates_test.rb",
     "test/model/event_test.rb",
     "test/model/comparison_test.rb",
     "test/provider_test_helper.rb",
     "test/provider/location_provider_test.rb",
     "test/provider/track_provider_test.rb",
     "test/provider/user_provider_test.rb",
     "test/provider/venue_provider_test.rb",
     "test/provider/tag_provider_test.rb",
     "test/provider/group_provider_test.rb",
     "test/provider/playlist_provider_test.rb",
     "test/provider/artist_provider_test.rb",
     "test/provider/album_provider_test.rb",
     "test/authentication_test.rb",
     "test/remote_test.rb",
     "test/build/remote_method_test.rb",
     "test/build/facade_builder_test.rb",
     "test/build/ruby_class_test.rb",
     "test/build/ruby_method_test.rb",
     "test/build/parameter_test.rb",
     "test/build/build_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0.9.2"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.2.3"])
    else
      s.add_dependency(%q<rest-client>, [">= 0.9.2"])
      s.add_dependency(%q<nokogiri>, [">= 1.2.3"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0.9.2"])
    s.add_dependency(%q<nokogiri>, [">= 1.2.3"])
  end
end
