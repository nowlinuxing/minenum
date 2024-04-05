# frozen_string_literal: true

require_relative 'enum'

module Minenum
  # = Minenum
  #
  # Minenum enhances Ruby objects by adding enum functionality.
  #
  #   class Shirt
  #     include Minenum::Model
  #
  #     enum :size, { small: 1, medium: 2, large: 3 }
  #   end
  #
  #   shirt = Shirt.new
  #   shirt.size = 1
  #   shirt.size.name #=> :small
  #   shirt.size.small? #=> true
  #
  #   # You can also set the name
  #   shirt.size = :medium
  #   shirt.size.name #=> :medium
  #   shirt.size.medium? #=> true
  #
  #   # You can get the enum values
  #   Shirt.size.values #=> { small: 1, medium: 2, large: 3 }
  #
  module Model
    module InstanceVariableAccessor # :nodoc:
      def set(model, name, value)
        enum = if model.instance_variable_defined?(:@_minenum_enum)
                 model.instance_variable_get(:@_minenum_enum)
               else
                 model.instance_variable_set(:@_minenum_enum, {})
               end
        enum[name] = value
      end
      module_function :set

      def get(model, name)
        enum = model.instance_variable_get(:@_minenum_enum)
        enum&.[](name)
      end
      module_function :get
    end

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods # :nodoc:
      def enum(name, values, adapter: InstanceVariableAccessor)
        enum_class = Enum::ClassBuilder.build(values)

        const_set(classify(name.to_s), enum_class)
        singleton_class.define_method(name) { enum_class }

        enum_methods_module.define_method("#{name}=") do |value|
          adapter.set(self, name, value)
        end

        enum_methods_module.define_method(name) do
          enum_class.new(adapter.get(self, name))
        end
      end

      private

      def enum_methods_module
        @enum_methods_module ||= begin
          mod = Module.new
          include mod
          mod
        end
      end

      def classify(key)
        key.gsub(/([a-z\d]+)_?/) { ::Regexp.last_match(1)&.capitalize }
      end
    end
  end
end
