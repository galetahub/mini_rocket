# frozen_string_literal: true

module MiniRocket
  class FilterProxy < FormProxy
    def url
      [MiniRocket.namespace, @parent, form].compact
    end

    def form
      @form ||= FilterForm.new(template.params[:filter])
    end

    def render(options, &block)
      options = {
        method: :get,
        url: template.collection_path,
        required: false,
        defaults: { required: false },
        wrapper: :mini_rocket_search
      }.merge!(options)

      super
    end

    def active?
      !form.params.nil?
    end

    def to_s
      with_parent_node { template.render(partial: 'filter_actions', locals: { form: form_builder }) }
      super
    end
  end
end
