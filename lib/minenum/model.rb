# frozen_string_literal: true

require_relative 'enum'
require_relative 'enum/adapter/local_instance_variable_accessor'
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
    def self.included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end

    module AccessorAdder # :nodoc:
      def add(model_class, methods_module, reflection)
        add_singleton_method(model_class, reflection)

        add_getter(methods_module, reflection)
        add_setter(methods_module, reflection)

        model_class._minenum_reflections[reflection.name] = reflection
      end
      module_function :add

      def add_singleton_method(model_class, reflection)
        model_class.singleton_class.define_method(reflection.name) do
          reflection.enum_class
        end
      end

      def add_getter(methods_module, reflection)
        methods_module.define_method(reflection.name) do
          _minenum_enum(reflection.name)
        end
      end

      def add_setter(methods_module, reflection)
        methods_module.define_method("#{reflection.name}=") do |value|
          _minenum_enum(reflection.name).value = value
        end
      end
      module_function :add_singleton_method, :add_getter, :add_setter
    end

    module ClassMethods # :nodoc:
      def enum(name, values, adapter_builder: Enum::Adapter::LocalInstanceVariableAccessor)
        reflection = Reflection.new(self, name, values, adapter_builder: adapter_builder)
        AccessorAdder.add(self, enum_methods_module, reflection)
      end

      def _minenum_reflections
        @_minenum_reflections ||= {}
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

    module InstanceMethods # :nodoc:
      private

      def _minenum_enum(name)
        @_minenum_enum ||= {}
        @_minenum_enum[name.to_sym] ||= self.class._minenum_reflections[name.to_sym].build_enum(self)
      end
    end
  end
end
