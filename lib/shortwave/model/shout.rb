module Shortwave
  module Model
    # A shout message on Last.fm
    #
    # === Attributes
    #
    # +message+:: The message text
    # +time+:: The time the message was written
    class Shout < BaseModel
      tag "shout"
      element :message, String, :tag => "body"
      element :time, Time, :tag => "date"
      element :author, String

      # The user who left the shout message
      def user
        @user ||= @session.user.build(:name => author)
      end
    end
  end
end
