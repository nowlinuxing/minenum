# frozen_string_literal: true

require_relative 'base'
require_relative 'values'

module Minenum
  module Enum
    class ClassBuilder # :nodoc:
      def self.build(values = {})
        new(values).build
      end

      def initialize(values)
        @values = values
      end

      def build
        values = Values.new(@values)

        klass = Class.new(Base)
        add_values_method(klass, values)
        add_name_method(klass, values)
        add_predicate_methods(klass, values)

        klass
      end

      private

      def add_values_method(klass, values)
        klass.singleton_class.define_method(:values) do
          values.values
        end
      end

      def add_name_method(klass, values)
        klass.define_method(:name) do
          values.key(@value)
        end
      end

      def add_predicate_methods(klass, values)
        values.each_key do |key|
          klass.define_method("#{key}?") do
            values.match?(key, @value)
          end
        end
      end
    end
  end
end
