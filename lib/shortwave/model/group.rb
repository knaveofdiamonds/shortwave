module Shortwave
  module Model
    class Group < BaseModel
      attr_accessor :name
      identified_by :name

      def members
        link :members, "User", name
      end
    end
  end
end
