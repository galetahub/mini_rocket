module MiniRocket
  # Sort scope via params sort_column=id and sort_mode=desc
  #
  class SortingQuery
    DIRECTIONS = %w[desc asc].freeze

    def initialize(scope, params, builder = nil)
      @scope = scope
      @params = params
      @builder = builder
      @index = builder.index
    end

    def valid_params?
      @params[:sort_column].present? &&
        available_columns.include?(@params[:sort_column]) &&
        DIRECTIONS.include?(@params[:sort_mode])
    end

    def valid_default?
      @index && @index.default_sort_column
    end

    def to_query
      if valid_params?
        collection.reorder(sort_column => sort_mode)
      elsif valid_default?
        collection.reorder(default_column => default_mode)
      else
        collection
      end
    end

    def sort_column
      @params[:sort_column]
    end

    def sort_mode
      @params[:sort_mode]
    end

    def default_column
      @index.default_sort_column.name
    end

    def default_mode
      @index.default_sort_column.sortable_mode
    end

    def available_columns
      @available_columns ||= @scope.column_names.map(&:to_s)
    end

    def collection
      @collection ||= apply_filters(@scope)
    end

    protected

    def apply_filters(scope)
      if @builder.filter? && scope.respond_to?(:filter)
        @scope.filter(@params)
      else
        @scope
      end
    end
  end
end
