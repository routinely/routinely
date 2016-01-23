require "administrate/fields/base"

module Administrate
  module Field
    class Time < Administrate::Field::Base
      def to_s
        data.to_formatted_s(:time)
      end
    end
  end
end
