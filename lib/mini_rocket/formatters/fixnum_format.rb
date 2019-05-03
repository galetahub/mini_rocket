# frozen_string_literal: true

module MiniRocket
  module Formatters
    class FixnumFormat < BaseFormat
      def render(template)
        object
      end
    end
  end
end
