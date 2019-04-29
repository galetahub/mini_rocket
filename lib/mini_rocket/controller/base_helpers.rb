# frozen_string_literal: true

module MiniRocket
  module Controller
    module BaseHelpers
      protected

      def mini_rocket?
        true
      end

      def scoped_collection
        @scoped_collection ||= ScopedQuery.new(sortable_collection, params, rocket_builder).to_query
      end

      def sortable_collection
        @sortable_collection ||= SortingQuery.new(paginated_collection, params, rocket_builder).to_query
      end

      def paginated_collection
        return end_of_association_chain unless rocket_builder.index.pagination?

        end_of_association_chain.page(params[:page]).per(rocket_builder.index.per_page)
      end

      def parent?
        !parent.nil?
      end

      def update_collection_order(resource_class, params)
        reorder_params = params.require(:items).map { |item| item.permit(:id, :sort_order) }

        reorder_ids        = reorder_params.map { |item| item[:id] }
        reorder_attributes = reorder_params.map { |item| item.slice(:sort_order) }

        resource_class.update(reorder_ids, reorder_attributes)
      end
    end
  end
end
