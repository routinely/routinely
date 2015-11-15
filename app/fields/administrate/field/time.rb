require "administrate/fields/base"

module Administrate
  module Field
    class Time < Administrate::Field::Base
      def to_s
        data
      end
    end
  end
end
