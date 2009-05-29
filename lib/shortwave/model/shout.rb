module Shortwave
  module Model
    class Shout < BaseModel
      tag "shout"
      element :body, String
      element :time, Time, :tag => "date"
      element :author, String

      def user
        @user ||= @session.user.build(:name => author)
      end
    end
  end
end
