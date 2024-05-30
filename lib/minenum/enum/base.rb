# frozen_string_literal: true

require 'forwardable'

module Minenum
  module Enum
    class Base # :nodoc:
      extend Forwardable

      attr_reader :value

      alias _inspect inspect
      def_delegators :value, :to_s, :to_sym, :inspect, :pretty_print

      def initialize(value)
        @value = value
        freeze
      end
    end
  end
end
