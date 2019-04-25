module MiniRocket
  module Formatters
    class StringFormat < BaseFormat
      def render(template)
        object.to_s
      end
    end
  end
end
