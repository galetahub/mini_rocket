# frozen_string_literal: true

require 'mini_rocket/components/component'

module MiniRocket
  module Components
    class AttributesTableFor < Component
      LAYOUT = 'section'

      def rows
        @rows ||= []
      end

      def row(name, options = {}, &block)
        rows << Column.new(name, options, &block)
      end

      def build
        super
        render(partial: 'attributes_table_for', locals: { rows: rows, title: title }, layout: layout)
      end

      def layout
        @options[:layout] || LAYOUT
      end

      def title
        @options[:title]
      end
    end
  end
end
