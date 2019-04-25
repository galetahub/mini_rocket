# frozen_string_literal: true

require 'mini_rocket/components/component'

module MiniRocket
  module Components
    class Panel < Component
      def build
        @title = (@args.first || self.class.name)

        render layout: 'panel', locals: { title: @title } do
          super
        end
      end
    end
  end
end
