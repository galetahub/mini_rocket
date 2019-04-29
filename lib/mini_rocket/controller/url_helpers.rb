# frozen_string_literal: true

module MiniRocket
  module Controller
    module UrlHelpers
      def collection_or_resource_path(*args)
        if rocket_builder.show?
          resource_path(*args)
        else
          collection_path
        end
      end

      def cancel_path
        record = get_resource_ivar

        if rocket_builder.show? && record.persisted?
          resource_path(record)
        elsif rocket_builder.index?
          collection_path
        elsif parent?
          parent_path
        end
      end

      def collection_or_parent_path
        if rocket_builder.index?
          collection_path
        elsif parent?
          parent_path
        end
      end

      def controller_namespace
        @controller_namespace ||= controller_path.split('/')[0]
      end
    end
  end
end
