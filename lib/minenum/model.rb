# frozen_string_literal: true

require_relative 'enum'
require_relative 'model/reflection'

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

    module AccessorAdder # :nodoc:
      def add(model_class, methods_module, reflection)
        add_singleton_method(model_class, reflection)

        add_getter(methods_module, reflection)
        add_setter(methods_module, reflection)
      end
      module_function :add

      def add_singleton_method(model_class, reflection)
        model_class.singleton_class.define_method(reflection.name) do
          reflection.enum_class
        end
      end

      def add_getter(methods_module, reflection)
        methods_module.define_method(reflection.name) do
          value = reflection.adapter.get(self, reflection.name)
          reflection.enum_class.new(value)
        end
      end

      def add_setter(methods_module, reflection)
        methods_module.define_method("#{reflection.name}=") do |value|
          reflection.adapter.set(self, reflection.name, value)
        end
      end
      module_function :add_singleton_method, :add_getter, :add_setter
    end

    module ClassMethods # :nodoc:
      def enum(name, values, adapter: InstanceVariableAccessor)
        reflection = Reflection.new(self, name, values, adapter: adapter)
        AccessorAdder.add(self, enum_methods_module, reflection)
      end

      private

      def enum_methods_module
        @enum_methods_module ||= begin
          mod = Module.new
          include mod
          mod
        end
      end
    end
  end
end
