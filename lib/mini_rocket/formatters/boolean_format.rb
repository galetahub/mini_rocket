# frozen_string_literal: true

module MiniRocket
  module Formatters
    class BooleanFormat < BaseFormat
      YES = 'yes'
      NO = 'no'

      def render(template)
        template.content_tag(:span, css_name, class: ['status_tag', css_name])
      end

      def css_name
        object ? YES : NO
      end
    end
  end
end
