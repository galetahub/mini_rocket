module MiniRocket
  module Controller
    class LocalizationBuilder
      attr_reader :form_builder, :inputs

      delegate :template, to: :form_builder

      Struct.new('Input', :name, :options)

      def initialize(form_builder, options = {}, &block)
        @form_builder = form_builder
        @options = options
        @block = block
      end

      def locales
        @locales ||= (@options[:locales] || I18n.available_locales)
      end

      def render
        @inputs = []
        instance_exec(&@block)
        template.render(partial: 'localization', locals: { builder: self, form: form_builder })
      end

      def input(name, options = {})
        @inputs << Struct::Input.new(name, options)
      end
    end
  end
end
