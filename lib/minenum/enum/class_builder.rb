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

        klass = Class.new(Base) do
          @_values = values
        end

        add_predicate_methods(klass, values)

        klass
      end

      private

      def add_predicate_methods(klass, values)
        values.each_key do |key|
          klass.class_eval <<~RUBY, __FILE__, __LINE__ + 1
            def #{key}?                                   # def size
              self.class._values.match?(:'#{key}', value) #   self.class._values.match?(:'size', value)
            end                                           # end
          RUBY
        end
      end
    end
  end
end
