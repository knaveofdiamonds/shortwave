module Shortwave
  module Model
    module WeeklyCharts
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
