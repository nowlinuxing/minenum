# frozen_string_literal: true

require 'forwardable'
require_relative 'adapter/local_instance_variable_accessor'

module Minenum
  module Enum
    class Base # :nodoc:
      extend Forwardable

      singleton_class.attr_reader :_values

      alias _inspect inspect
      def_delegators :name, :to_s, :to_sym, :inspect, :pretty_print

      def self.values
        _values.values
      end

      def initialize(adapter = Adapter::LocalInstanceVariableAccessor.new)
        @adapter = adapter
      end

      def name
        self.class._values.key(_raw_value)
      end

      def value
        self.class._values.value(_raw_value)
      end

      def value=(value)
        @adapter.set(self.class._values.value(value))
      end

      private

      def _raw_value
        @adapter.get
      end
    end
  end
end
