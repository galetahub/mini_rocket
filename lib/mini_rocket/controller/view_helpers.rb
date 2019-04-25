module MiniRocket
  module Controller
    module ViewHelpers
      def table_column_tag(column, options = {}, &block)
        if column.sortable?
          table_sorting_column_tag(column, options, &block)
        else
          content_tag(:th, capture(&block), options)
        end
      end

      def table_sorting_column_tag(column, options = {}, &block)
        parser = MiniRocket::SortingParser.new(column, params)

        options[:class] = [options[:class], parser.class_name].compact
        new_params = params.merge(sort_column: parser.sort_column, sort_mode: parser.next_mode).permit!

        content_tag(:th, options) do
          link_to(capture(&block), new_params, data: { 'turbolinks-action' => 'replace' })
        end
      end

      def status_tag(value, class_name = nil)
        content_tag(:span, value, class: ['label', "label-#{value.to_s.parameterize}", class_name].compact)
      end

      def render_resource_title(resource)
        MiniRocket::Titleizer.record_to_title(resource)
      end

      def render_cleancms_page_title
        MiniRocket::Titleizer.new(controller, params).render
      end
    end
  end
end
