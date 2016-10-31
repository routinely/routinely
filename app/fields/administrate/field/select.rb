require "administrate/fields/base"

module Administrate
  module Field
    class Select < Administrate::Field::Base
      def to_s
        data
      end

      def choices
        options.fetch(:choices)
      end
    end
  end
end
