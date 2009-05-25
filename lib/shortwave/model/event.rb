module Shortwave
  module Model
    class Event
      include HappyMapper

      tag "event"
      element :id, Integer
    end
  end
end
