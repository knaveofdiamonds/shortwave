module Shortwave
  module Model
    class Location < BaseModel
      tag "point"
      namespace "geo"
      element :latitude, Float, :tag => "lat"
      element :longitude, Float, :tag => "long"
    end
  end
end
