# frozen_string_literal: true

module Minenum
  module Enum
    class Values # :nodoc:
      attr_reader :values

      def initialize(values)
        @values = values.transform_keys(&:to_sym).tap(&:freeze)
        freeze
      end

      def each_key(...)
        @values.each_key(...)
      end

      def key(key_or_value)
        if key_or_value.respond_to?(:to_sym) && (key_sym = key_or_value.to_sym) && @values.key?(key_sym)
          key_sym
        else
          return @values.key(key_or_value) if @values.value?(key_or_value)

          case key_or_value
          when Symbol then @values.key(key_or_value.to_s)
          when String then @values.key(key_or_value.to_sym)
          end
        end
      end

      def match?(key_name, key_or_value)
        if key_or_value.respond_to?(:to_sym) && (key_sym = key_or_value.to_sym) && @values.key?(key_sym)
          key_sym == key_name.to_sym
        else
          match_with_value?(key_name, key_or_value)
        end
      end

      private

      def match_with_value?(key_name, value)
        registered_value = @values[key_name.to_sym]
        return true if value == registered_value

        case value
        when Symbol then value.to_s == registered_value
        when String then value.to_sym == registered_value
        else false
        end
      end
    end
  end
end
