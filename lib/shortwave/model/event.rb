module Shortwave
  module Model
    class Event < BaseModel
      element :id, Integer
      element :description, String
      element :url, String
      element :attendance_count, Integer, :tag => "attendance"
      element :review_count, Integer, :tag => "reviews"
      element :starts_at, Time, :tag => "startDate"
      element :name, String, :tag => "title"
      element :headliner_raw, Artist, :tag => "artsits/headliner"
      element :artists_raw, String, :tag => "artists/artist", :single => false
      
      def artists
        @artists ||= artists_raw.map {|a| @session.artist.build(:name => a) }
      end
    end
  end
end
