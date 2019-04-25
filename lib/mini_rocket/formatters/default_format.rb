module MiniRocket
  module Formatters
    class DefaultFormat < BaseFormat
      def render(template)
        template.render_resource_title(object)
      end
    end
  end
end
