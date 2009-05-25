module Shortwave
  module Model
    class Event
      include HappyMapper

      tag "event"
      element :id, Integer
      element :description, String
      element :url, String
      element :attendance_count, Integer, :tag => "attendance"
      element :starts_at, Time, :tag => "startDate"
      element :name, String, :tag => "title"
    end
  end
end
