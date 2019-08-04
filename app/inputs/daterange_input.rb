# frozen_string_literal: true

require 'simple_form'

class DaterangeInput < ::SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    template.content_tag :div, class: 'input-group col-md-5 no-padding' do
      @builder.text_field(attribute_name, merged_input_options) + icon_tag
    end
  end

  protected

  def icon_tag
    template.content_tag(:span, class: 'input-group-addon') do
      template.content_tag(:i, nil, class: 'fas fa-calendar-alt')
    end
  end
end
