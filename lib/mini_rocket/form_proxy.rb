# frozen_string_literal: true

module MiniRocket
  class FormProxy < ComponentProxy
    include MiniRocket::Components::Panelable

    attr_reader :form_builder, :template, :resource

    delegate :object, to: :form_builder

    CLOSING_TAG = '</form>'

    def initialize(resource, parent, template)
      @resource = resource
      @template = template
      @parent = parent
    end

    def render(options, &block)
      @form_builder = nil
      endpoint = build_endpoint(options.delete(:url))

      form_string = template.simple_form_for(endpoint, options.deep_dup) do |form|
        @form_builder = form
      end

      @opening_tag, @closing_tag = split_string_on(form_string, CLOSING_TAG)

      instance_exec(self, &block)
      to_s
    end

    def multipart?
      form_builder.present? && form_builder.multipart?
    end

    def inputs(label, &block)
      label = label.is_a?(Symbol) ? I18n.t("mini_rocket.form.inputs.#{label}") : label
      with_parent_node { form_builder.inputs(label, &block) }
    end

    def localization(*args, &block)
      with_parent_node { form_builder.localization(*args, &block) }
    end

    def has_many(*args, &block)
      form_builder.has_many(*args, &block)
    end

    protected

    def method_missing(method, *args, &block)
      if form_builder && form_builder.respond_to?(method)
        proxy_call_to_form(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      form_builder && form_builder.respond_to?(method) || super
    end

    def current_node
      (@parent_node || children)
    end

    def proxy_call_to_form(method_name, *args, &block)
      current_node.concat form_builder.send(method_name, *args, &block)
    end

    def with_parent_node
      @parent_node = ''.html_safe
      children.concat yield
      @parent_node = nil
    end

    private

    def build_endpoint(endpoint)
      return url unless endpoint

      case endpoint
      when Proc then
        endpoint.call(*[@parent, @resource].compact)
      else
        endpoint
      end
    end

    def url
      [MiniRocket.namespace, @parent, @resource].compact
    end
  end
end
