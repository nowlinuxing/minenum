# frozen_string_literal: true

module Minenum
  module Enum
    class Values # :nodoc:
      attr_reader :values

      def initialize(values)
        @values = values.transform_keys(&:to_sym).transform_values(&:freeze).tap(&:freeze)
        freeze
      end

      def each_key(...)
        @values.each_key(...)
      end

      def key(key_or_value)
        return key_or_value if @values.key?(key_or_value)
        return @values.key(key_or_value) if @values.value?(key_or_value)

        return key_or_value.to_sym if match_as_key?(key_or_value)

        find_by_key(key_or_value)
      end

      def value(key_or_value)
        return @values.values.find { _1 == key_or_value } if @values.value?(key_or_value)
        return @values[key_or_value] if @values.key?(key_or_value)

        val = find_by_value(key_or_value)
        return val if val

        @values[key_or_value.to_sym] if match_as_key?(key_or_value)
      end

      def match?(key_name, key_or_value)
        key(key_or_value) == key_name.to_sym
      end

      private

      def match_as_key?(key_or_value)
        return false unless key_or_value.respond_to?(:to_sym)

        @values.key?(key_or_value.to_sym)
      end

      def find_by_key(key_or_value)
        case key_or_value
        when Symbol then @values.key(key_or_value.to_s)
        when String then @values.key(key_or_value.to_sym)
        end
      end

      def find_by_value(key_or_value)
        case key_or_value
        when Symbol then value = key_or_value.to_s
        when String then value = key_or_value.to_sym
        else
          return
        end

        @values.values.find { _1 == value }
      end
    end
  end
end
