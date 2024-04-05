# frozen_string_literal: true

module Minenum
  module Enum
    class Base # :nodoc:
      attr_reader :value

      def initialize(value)
        @value = value
        freeze
      end
    end
  end
end
