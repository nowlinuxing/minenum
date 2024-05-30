# frozen_string_literal: true

require_relative 'base'

module Minenum
  module Enum
    module Adapter
      class LocalInstanceVariableAccessor < Base # :nodoc:
        def initialize(enum_object = nil, name = nil)
          super
          @value = nil
        end

        def get
          @value
        end

        def set(value)
          @value = value
        end
      end
    end
  end
end
