# frozen_string_literal: true

require 'mini_rocket/components/columnable'

module MiniRocket
  module Actions
    class Index < Base
      include MiniRocket::Components::Columnable

      def pagination?
        @options[:pagination] != false
      end

      def per_page
        @options[:per_page] || MiniRocket.paginates_per
      end

      def title(klass)
        @options[:title] || klass.model_name.human
      end

      def call
        reset!
        instance_exec(&@block)
      end

      def reset!
        @columns = nil
      end
    end
  end
end
