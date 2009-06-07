module Shortwave
  module Model
    # A chart date range. This is only really used internally.
    #
    # === Attributes
    #
    # from:: the date the chart starts
    # to:: the date the chart finishes
    class ChartDates < BaseModel
      tag "chart"
      attribute :from, Time
      attribute :to, Time
    end
  end
end
