module Policeable
  extend ActiveSupport::Concern

  included do
    class << self
      def policy_class
        RoutinePolicy
      end
    end
  end
end
