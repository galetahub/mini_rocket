module MiniRocket
  module Components
    class Component
      attr_reader :holder

      delegate :assigns, :helpers, to: :holder
      delegate :render, to: :helpers

      def initialize(holder, *args, &block)
        @holder = holder
        @options = args.extract_options!
        @args = args
        @block = block
      end

      def build
        instance_exec(self, &@block)
      end

      def method_missing(method, *args, &block)
        if helpers.respond_to?(method)
          helpers.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        helpers.respond_to?(method) || super
      end
    end
  end
end
