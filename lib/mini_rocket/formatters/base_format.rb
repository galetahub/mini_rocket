# frozen_string_literal: true

module MiniRocket
  module Formatters
    class BaseFormat
      attr_reader :resource, :method_name

      def initialize(resource, method_name, options = {})
        @resource = resource
        @method_name = method_name
        @options = options
        @object = options[:object]
      end

      def render(template)
      end

      def object
        @object ||= @resource.send(@method_name)
      end
    end
  end
end
