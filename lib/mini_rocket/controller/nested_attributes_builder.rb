# frozen_string_literal: true

module MiniRocket
  module Controller
    class NestedAttributesBuilder
      attr_reader :form_builder, :inputs, :method_name

      delegate :template, to: :form_builder

      Struct.new('Input', :name, :options)

      def initialize(form_builder, method_name, options = {}, &block)
        @form_builder = form_builder
        @method_name = method_name
        @options = options
        @block = block
      end

      def multiple?
        @options[:multiple]
      end

      def render
        @inputs = []
        instance_exec(&@block)
        template.render(partial: 'nested_attributes', locals: { builder: self, form: @form_builder })
      end

      def input(name, options = {})
        options[:class] ||= 'form-control'
        @inputs << Struct::Input.new(name, options)
      end
    end
  end
end
