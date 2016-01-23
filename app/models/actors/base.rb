module Actors
  class Base < Actor
    class << self
      def sti_name
        name.demodulize
      end
    end
  end
end
