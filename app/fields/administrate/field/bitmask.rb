require "administrate/fields/base"

module Administrate
  module Field
    class Bitmask < Administrate::Field::Base
      def to_s
        data
      end
    end
  end
end
