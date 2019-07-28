# frozen_string_literal: true

module MiniRocket
  module ResourcesHelper
    include MiniRocket::Controller::ViewHelpers

    def menu_link(name, path, options = {})
      options[:class] = 'left-menu-link'
      active = options[:names] && Array(options[:names]).include?(controller_name) || current_page?(path)

      content_tag(:li, class: [active ? 'active' : 'noactive']) do
        link_to(path, options) do
          content_tag(:i, '', class: ['fa', options[:icon]]) + content_tag(:span, name)
        end
      end
    end

    def link_to_add_fields(name = nil, f = nil, association = nil, options = nil, html_options = nil, &block)
      # If a block is provided there is no name attribute and the arguments are
      # shifted with one position to the left. This re-assigns those values.
      f, association, options, html_options = name, f, association, options if block_given?

      options = {} if options.nil?
      html_options = {} if html_options.nil?

      locals = (options[:locals] || {})
      partial = (options[:partial] || 'nested_item_fields')

      # Render the form fields from a file with the association name provided
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object, child_index: 'new_record') do |builder|
        render(partial, locals.merge!(form: builder))
      end

      # The rendered fields are sent with the link within the data-form-prepend attr
      html_options['data-form-prepend'] = h(fields)
      html_options['href'] = '#'

      content_tag(:a, name, html_options, &block)
    end
  end
end
