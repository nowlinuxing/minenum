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
        add_singleton_method(model_class, reflection.name)

        add_getter(methods_module, reflection.name)
        add_setter(methods_module, reflection.name)

        model_class._minenum_reflections[reflection.name] = reflection
      end
      module_function :add

      def add_singleton_method(model_class, name)
        model_class.class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def self.#{name}                              # def self.size
            _minenum_reflections[:'#{name}'].enum_class #   _minenum_reflections[:'size'].enum_class
          end                                           # end
        RUBY
      end

      def add_getter(methods_module, name)
        methods_module.module_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{name}                 # def size
            _minenum_enum(:'#{name}') #   _minenum_enum(:'size')
          end                         # end
        RUBY
      end

      def add_setter(methods_module, name)
        methods_module.module_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{name}=(value)                       # def size=(value)
            _minenum_enum(:'#{name}').value = value #   _minenum_enum(:'size').value = value
          end                                       # end
        RUBY
      end
      module_function :add_singleton_method, :add_getter, :add_setter
    end

    module ClassMethods # :nodoc:
      def enum(name, values)
        _minenum_enum(name, values, _minenum_methods_module)
      end

      def _minenum_reflections
        @_minenum_reflections ||= {}
      end

      private

      def _minenum_enum(name, values, methods_module, adapter_builder: nil)
        adapter_builder ||= Enum::Adapter::LocalInstanceVariableAccessor

        reflection = Reflection.new(self, name, values, adapter_builder: adapter_builder)
        AccessorAdder.add(self, methods_module, reflection)
      end

      def _minenum_methods_module
        @_minenum_methods_module ||= begin
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
