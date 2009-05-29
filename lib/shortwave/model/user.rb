module Shortwave
  module Model
    class User < BaseModel
      element :name, String
      shoutable :name
    end
  end
end
