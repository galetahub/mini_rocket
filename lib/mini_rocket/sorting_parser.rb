# frozen_string_literal: true

module MiniRocket
  # Extract sort options from params or column
  #
  class SortingParser
    DEFAULT_CLASS_NAME = 'sorting'

    def initialize(column, params)
      @column = column
      @params = params
    end

    def current?
      sort_column == @params[:sort_column]
    end

    def default?
      @params[:sort_column].blank? && @column.sortable_by_default?
    end

    def active?
      current? || default?
    end

    def class_name
      if active?
        "sorting_#{sort_mode}"
      else
        DEFAULT_CLASS_NAME
      end
    end

    def sort_column
      @column.name.to_s
    end

    def sort_mode
      if @params[:sort_mode].blank? && default?
        @column.sortable_mode
      else
        @params[:sort_mode]
      end
    end

    def next_mode
      @next_mode ||= (sort_mode == 'asc' ? 'desc' : 'asc')
    end
  end
end
