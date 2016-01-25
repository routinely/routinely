require "administrate/fields/base"

module Administrate
  module Field
    class Asset < Administrate::Field::Base
      def candidates
        Dir.chdir("app/assets/images") do
          Dir.glob("**/*").select { |f| File.file?(f) }
        end
      end
    end
  end
end
