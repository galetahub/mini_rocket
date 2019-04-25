module MiniRocket
  module Actions
    class Base
      attr_reader :options, :block

      def initialize(options = {}, &block)
        @options = options.freeze
        @block = block
      end
    end
  end
end
