module Shortwave
  module Model
    class Playlist < BaseModel
      element :id, Integer
      element :title, String
      element :description, String
      element :created_at, Time, :tag => "date"
      element :size, Integer
      element :duration, Integer
      element :streamable, Boolean
      element :creator_url, String, :tag => "creator"
      element :url, String

      def streamable?
        @streamable
      end
    end
  end
end
