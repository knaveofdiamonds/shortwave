module Shortwave
  module Model
    # A Last.fm user group.
    #
    # === Attributes
    #
    # name:: the group name
    class Group < BaseModel
      attr_accessor :name
      identified_by :name

      # Returns the group's members. Currently only 50 users are returned
      def members
        link :members, "User", name
      end

      # Returns the most popular albums from this group for the last week
      def album_chart
        link :weekly_album_chart, "Album", name
      end

      # Returns the most popular artists from this group for the last week
      def artist_chart
        link :weekly_artist_chart, "Artist", name
      end

      # Returns the most popular tracks from this group for the last week
      def track_chart
        link :weekly_track_chart, "Track", name
      end

      # Returns an array of Time ranges, repesenting the weeks charts are available
      def chart_dates
        @chart_dates ||= charts.map {|cd| cd.from..cd.to }.reverse
      end

      private

      def charts
        @charts ||= link :weekly_chart_list, "ChartDates", name
      end
    end
  end
end
