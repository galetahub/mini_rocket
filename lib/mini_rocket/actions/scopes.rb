module MiniRocket
  module Actions
    class Scopes < Base
      def scope(name, options = {}, &block)
        scope = Components::Scope.new(name, options, &block)
        scope.id = @items.size

        @items << scope
      end

      def call
        @items = []
        instance_exec(&@block)
      end

      def render(collection, params = {})
        return if @items.nil?

        @items.each do |item|
          item.configure(collection, params)
          yield item
        end
      end

      def find_active(params)
        return if params[:scope].blank? || @items.nil?

        @items.detect { |item| item.to_param == params[:scope] }
      end
    end
  end
end
