module Shortwave
  module Model
    class User < BaseModel
      element :name, String
      element :id, Integer
      element :real_name, String, :tag => "realname"
      element :url, String
      element :image, String
      element :language, String, :tag => "lang"
      element :country, String
      element :age, Integer
      element :gender, String
      element :subscriber, Boolean
      element :play_count, Integer, :tag => "playcount"

      shoutable :name
    end
  end
end
