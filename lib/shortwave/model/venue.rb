module Shortwave
  module Model
    class Location
      include HappyMapper

      tag "location"
      
    end

    class Venue
      include HappyMapper
      
      tag "venue"
      element :name, String
      element :url, String
      has_one :location, Location
    end
  end
end
