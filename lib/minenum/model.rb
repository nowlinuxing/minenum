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

    module AccessorAdder # :nodoc:
      def add(model_class, methods_module, name, enum_class, adapter)
        add_singleton_method(model_class, name, enum_class)

        add_getter(methods_module, name, enum_class, adapter)
        add_setter(methods_module, name, adapter)
      end
      module_function :add

      def add_singleton_method(model_class, name, enum_class)
        model_class.singleton_class.define_method(name) { enum_class }
      end

      def add_getter(methods_module, name, enum_class, adapter)
        methods_module.define_method(name) do
          enum_class.new(adapter.get(self, name))
        end
      end

      def add_setter(methods_module, name, adapter)
        methods_module.define_method("#{name}=") do |value|
          adapter.set(self, name, value)
        end
      end
      module_function :add_singleton_method, :add_getter, :add_setter
    end

    module ClassMethods # :nodoc:
      def enum(name, values, adapter: InstanceVariableAccessor)
        enum_class = Enum::ClassBuilder.build(values)
        const_set(classify(name.to_s), enum_class)

        AccessorAdder.add(self, enum_methods_module, name.to_sym, enum_class, adapter)
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
