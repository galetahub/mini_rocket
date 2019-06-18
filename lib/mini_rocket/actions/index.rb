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
        render_title(@options[:title]) || klass.model_name.human
      end

      def css(klass)
        @options[:class] || klass.model_name.plural
      end

      def call
        reset!
        instance_exec(&@block)
      end

      def reset!
        @columns = nil
      end

      private

      def render_title(value)
        return if value.blank?

        value.respond_to?(:call) ? value.call : value
      end
    end
  end
end
