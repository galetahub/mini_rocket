# frozen_string_literal: true

module MiniRocket
  module Components
    class Column
      attr_reader :name, :options

      def initialize(name, options = {}, &block)
        @name = name
        @options = options
        @block = block
      end

      def title
        @title ||= @name.to_s.humanize
      end

      def render_title(resource_class)
        case @name
        when Symbol then resource_class.human_attribute_name(@name)
        else
          title
        end
      end

      def render(resource, template)
        block? ? render_block(resource, template) : render_value(resource, template)
      end

      def block?
        !@block.nil?
      end

      def sortable?
        sortable == true || sortable.is_a?(Hash)
      end

      def sortable
        @options[:sortable]
      end

      def sortable_by_default?
        sortable? && sortable.is_a?(Hash) && sortable[:default]
      end

      def sortable_mode
        mode = sortable[:default]

        if SortingQuery::DIRECTIONS.include?(mode.to_s)
          mode
        else
          SortingQuery::DIRECTIONS[1]
        end
      end

      def render_block(resource, template)
        template.instance_exec(resource, &@block)
      end

      def render_value(resource, template)
        options = { object: resource.send(@name) }.merge(@options)
        Formatters.build(resource, @name, options).render(template)
      end
    end
  end
end
