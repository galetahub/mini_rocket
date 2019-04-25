module MiniRocket
  module Components
    module Panelable
      def panel(title, options = {}, &block)
        panels << Column.new(title, options, &block)
      end

      def panels
        @panels ||= []
      end

      def panels?
        !panels.empty?
      end
    end
  end
end
