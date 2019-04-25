module MiniRocket
  module Components
    class ReorderableColumn < Column
      DEFAULT_URL = '/reorder'.freeze
      DEFAULT_CSS_NAME = 'js-reorder-table'.freeze

      def render(_resource, template)
        template.content_tag(:i, nil, class: 'icmn-move js-reorder-handle')
      end

      def css_name
        DEFAULT_CSS_NAME
      end

      def url
        if @options[:url]
          @options[:url].call
        else
          DEFAULT_URL
        end
      end
    end
  end
end
