require File.dirname(__FILE__) + "/weekly_charts"

module Shortwave
  module Model
    # A Last.fm user group.
    #
    # === Attributes
    #
    # name:: the group name
    class Group < BaseModel
      attr_accessor :name
      identified_by :name
      include WeeklyCharts

      # Returns the group's members. Currently only 50 users are returned
      def members
        link :members, "User", name
      end
    end
  end
end
