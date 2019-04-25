module MiniRocket
  module Formatters
    class IdFormat < BaseFormat
      def render(template)
        if template.rocket_builder.show?
          template.link_to(object, template.resource_path(resource))
        else
          object.to_s
        end
      end
    end
  end
end
