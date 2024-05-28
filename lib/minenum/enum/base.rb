# frozen_string_literal: true

require 'forwardable'

module Minenum
  module Enum
    class Base # :nodoc:
      extend Forwardable

      attr_reader :value

      singleton_class.attr_reader :_values

      alias _inspect inspect
      def_delegators :name, :to_s, :to_sym, :inspect, :pretty_print

      def self.values
        _values.values
      end

      def initialize(value)
        @value = value
        freeze
      end

      def name
        self.class._values.key(@value)
      end
    end
  end
end
