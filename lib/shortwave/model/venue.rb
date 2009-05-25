module Shortwave
  module Model
    class Venue
      include HappyMapper
      
      tag "venue"
      element :name, String
      element :url, String
    end
  end
end
