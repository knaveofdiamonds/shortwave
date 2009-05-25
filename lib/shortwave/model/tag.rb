module Shortwave
  module Model
    class Tag
      include HappyMapper
      
      tag 'tag'
      element :name, String
      element :count, Integer
      element :url, String
    end
  end
end
