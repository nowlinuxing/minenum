# frozen_string_literal: true

require_relative '../enum/class_builder'
require_relative '../enum/adapter/local_instance_variable_accessor'

module Minenum
  module Model
    class Reflection # :nodoc:
      attr_reader :adapter_builder

      def initialize(owner_class, name, values, adapter_builder: Enum::Adapter::LocalInstanceVariableAccessor)
        @owner_class = owner_class
        @name = name
        @values = values

        @adapter_builder = adapter_builder
      end

      def name
        @name.to_sym
      end

      def enum_class
        @enum_class ||= begin
          basename = classify(@name.to_s)

          if @owner_class.const_defined?(basename, false)
            @owner_class.const_get(basename, false)
          else
            klass = Enum::ClassBuilder.build(@values)
            @owner_class.const_set(basename, klass)
          end
        end
      end

      def build_enum(model)
        adapter = @adapter_builder.build(model, @name)
        enum_class.new(adapter)
      end

      private

      def classify(key)
        key.gsub(/([a-z\d]+)_?/) { ::Regexp.last_match(1)&.capitalize }
      end
    end
  end
end
