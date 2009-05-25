module Shortwave
  module Model
    class Tag
      include HappyMapper
      
      tag 'tag'
      element :name, String
      element :count, Integer
      element :url, String

      attr_accessor :session
    end
  end
end
