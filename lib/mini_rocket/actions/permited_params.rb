# frozen_string_literal: true

module MiniRocket
  module Actions
    class PermitedParams
      def initialize(*args)
        @args = args
      end

      def all?
        @args.length == 1 && @args[0] == :all
      end

      def attributes
        @args
      end

      def permit(resource_class, params)
        key = ActiveModel::Naming.param_key(resource_class)
        hash = params.fetch(key, {})

        if all?
          [hash.permit!]
        else
          [hash.permit(*attributes)]
        end
      end
    end
  end
end
