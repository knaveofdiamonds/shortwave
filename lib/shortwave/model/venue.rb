module Shortwave
  module Model
    class Venue
      include HappyMapper
      
      tag "venue"
      element :name, String
    end
  end
end
