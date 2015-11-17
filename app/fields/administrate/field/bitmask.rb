require "administrate/fields/base"

module Administrate
  module Field
    class Bitmask < Administrate::Field::Base
      def self.permitted_attribute(attr)
        { attr => [] }
      end

      def to_s
        data
      end
    end
  end
end
