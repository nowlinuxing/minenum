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

        values.each_key do |key|
          add_predicate_method(klass, key)
          add_bang_method(klass, key)
        end

        klass
      end

      private

      def add_predicate_method(klass, key)
        klass.class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{key}?                                   # def small?
            self.class._values.match?(:'#{key}', value) #   self.class._values.match?(:'small', value)
          end                                           # end
        RUBY
      end

      def add_bang_method(klass, key)
        klass.class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{key}!              # def small!
            self.value = :'#{key}' #   self.value = :'small'
          end                      # end
        RUBY
      end
    end
  end
end
