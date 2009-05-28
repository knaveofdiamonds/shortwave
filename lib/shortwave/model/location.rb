module Shortwave
  module Model
    class Location < BaseModel
      tag "location"
      element :latitude, Float, :tag => "geo:point/geo:lat"
      element :longitude, Float, :tag => "geo:point/geo:long"
      element :city, String
      element :country, String
      element :street_address, String, :tag => "street"
      element :postcode, String, :tag => "postalcode"
    end
  end
end
