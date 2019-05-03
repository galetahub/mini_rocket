# frozen_string_literal: true

require 'simple_form'

SimpleForm.setup do |config|
  config.wrappers :mini_rocket, class: 'form-group row', error_class: 'has-danger' do |b|
    b.use :html5
    b.use :placeholder

    b.wrapper tag: :div, class: 'col-md-3' do |c|
      c.use :label, class: 'form-control-label'
    end

    b.wrapper tag: :div, class: 'col-md-9' do |c|
      c.use :input, class: 'form-control'
      c.use :hint,  wrap_with: { tag: :small, class: 'form-control-hint' }
      c.use :error, wrap_with: { tag: :div, class: 'form-control-error' }
    end
  end

  config.wrappers :inline_checkbox, tag: 'div', class: 'form-group row', error_class: 'has-danger' do |b|
    b.use :html5

    b.wrapper tag: :div, class: 'col-md-9 col-md-offset-3' do |c|
      c.wrapper tag: 'div', class: 'checkbox-control' do |ba|
        ba.use :label_input, wrap_with: { class: 'checkbox inline' }

        ba.use :hint,  wrap_with: { tag: :small, class: 'form-control-hint' }
        ba.use :error, wrap_with: { tag: :div, class: 'form-control-error' }
      end
    end
  end

  config.wrappers :mini_rocket_search, class: 'form-group row', error_class: 'has-danger' do |b|
    b.use :html5
    b.use :placeholder

    b.wrapper tag: :div, class: 'col-md-12' do |c|
      c.use :label, class: 'form-control-label'
      c.use :input, class: 'form-control'
      c.use :hint,  wrap_with: { tag: :small, class: 'form-control-hint' }
      c.use :error, wrap_with: { tag: :div, class: 'form-control-error' }
    end
  end
end
