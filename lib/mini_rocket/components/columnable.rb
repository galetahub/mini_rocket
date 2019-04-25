module MiniRocket
  module Components
    module Columnable
      def columns
        @columns ||= []
      end

      def id_column(options = {})
        options[:as] ||= :id
        column(:id, options)
      end

      def column(name, options = {}, &block)
        options = default_column_optoins.merge!(options)
        columns << Column.new(name, options, &block)
      end

      def actions
        columns << ColumnActions.new(:actions)
      end

      def reorderable_column(options = {}, &block)
        @reorderable = ReorderableColumn.new(:reorder, options, &block)
        columns << @reorderable
      end

      def reorderable?
        !@reorderable.nil?
      end

      def default_sort_column
        @default_sort_column ||= columns.detect(&:sortable_by_default?)
      end

      def default_column_optoins
        { sortable: MiniRocket.sortable }
      end
    end
  end
end
