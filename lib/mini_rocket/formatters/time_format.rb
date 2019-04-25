module MiniRocket
  module Formatters
    class TimeFormat < BaseFormat
      def render(_template)
        I18n.l(object, format: :long)
      end
    end
  end
end
