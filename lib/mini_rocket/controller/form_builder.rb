require 'simple_form'

module MiniRocket
  module Controller
    class FormBuilder < ::SimpleForm::FormBuilder
      def inputs(name, &block)
        template.field_set_tag(name, &block)
      end

      def actions
        template.render(partial: 'form_actions', locals: { form: self })
      end

      def localization(options = {}, &block)
        LocalizationBuilder.new(self, options, &block).render
      end

      def has_many(method_name, options = {}, &block)
        options = { multiple: true }.merge!(options)
        NestedAttributesBuilder.new(self, method_name, options, &block).render
      end
    end
  end
end
