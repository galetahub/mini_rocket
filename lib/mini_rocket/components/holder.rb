require 'cleancms/components/panel'
require 'cleancms/components/attributes_table_for'
require 'cleancms/components/table_for'

module MiniRocket
  module Components
    class Holder
      attr_reader :assigns, :helpers

      def initialize(assigns = {}, helpers = nil)
        @assigns = assigns
        @helpers = helpers
      end

      def build(&block)
        instance_exec(@assigns[:resource], &block)

        components.collect(&:build).join('').html_safe
      end

      def components
        @components ||= []
      end

      def add_component(element)
        components << element
      end

      def method_missing(method_name, *args, &block)
        klass = find_component_class(method_name)

        if klass
          component = klass.new(self, *args, &block)
          add_component(component)
        elsif @helpers.respond_to?(method_name)
          @helpers.send(method_name, *args, &block)
        else
          super
        end
      end

      protected

      def find_component_class(name)
        return if name.blank?

        klass = name.to_s.classify
        return unless MiniRocket::Components.const_defined?(klass)
        "MiniRocket::Components::#{klass}".constantize
      end
    end
  end
end
