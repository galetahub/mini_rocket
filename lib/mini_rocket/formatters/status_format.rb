module MiniRocket
  module Formatters
    class StatusFormat < BaseFormat
      def render(template)
        template.status_tag(object, class: css_name)
      end

      def css_name
        object.to_s.underscore.tr('/', '_')
      end
    end
  end
end
