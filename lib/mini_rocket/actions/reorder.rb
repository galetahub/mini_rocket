module MiniRocket
  module Actions
    class Reorder < Base
      DEFAULTS = { column: :sort_order }.freeze

      def initialize(options = {}, &block)
        @options = DEFAULTS.dup.merge!(options)
        @block = block
      end

      def collection(scope = nil)
        if scope
          @collection = scope
        else
          @collection
        end
      end

      def column
        @options[:column]
      end

      def render(template)
        instance_exec(&@block)
        @collection = evalute(@collection, template)

        template.render(partial: 'reorder_item', collection: @collection, as: :item)
      end

      protected

      def evalute(scope, template)
        if scope.is_a?(Proc)
          template.instance_exec(&scope)
        else
          scope
        end
      end
    end
  end
end
