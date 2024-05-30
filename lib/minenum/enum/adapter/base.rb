# frozen_string_literal: true

module Minenum
  module Enum
    module Adapter
      class Base # :nodoc:
        def self.build(enum_object, name)
          new(enum_object, name)
        end

        def initialize(enum_object, name)
          @enum_object = enum_object
          @name = name
        end

        def get
          raise NotImplementedError
        end

        def set(_value)
          raise NotImplementedError
        end
      end
    end
  end
end
