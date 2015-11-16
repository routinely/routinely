require "administrate/fields/base"

module Administrate
  module Field
    class Enum < Administrate::Field::Base
      def to_s
        data
      end
    end
  end
end
