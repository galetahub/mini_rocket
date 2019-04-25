require 'cleancms/components/component'
require 'cleancms/components/columnable'

module MiniRocket
  module Components
    class TableFor < Component
      include MiniRocket::Components::Columnable

      LAYOUT = 'panel'.freeze

      attr_reader :collection, :bottom_block

      def bottom(&block)
        @bottom_block = block
      end

      def build
        super

        @collection = @args[1].call
        @title = @args[0].is_a?(Symbol) ? I18n.t("cleancms.table_for.#{@args[0]}") : @title

        render(partial: 'table_for', locals: { component: self, title: @title }, layout: layout)
      end

      def default_column_optoins
        { sortable: MiniRocket.sortable }
      end

      def layout
        @options[:layout] || LAYOUT
      end

      def html_options
        {
          class: ['table table-hover dataTable', reorderable_html_css],
          data: reorderable_html_data
        }
      end

      protected

      def reorderable_html_css
        reorderable? ? @reorderable.css_name : 'no-reorder'
      end

      def reorderable_html_data
        return unless reorderable?

        {
          url: @reorderable.url
        }
      end
    end
  end
end
