# frozen_string_literal: true

module MiniRocket
  class Titleizer
    ACTION_ALIASES = { create: :new, update: :edit }.freeze

    def self.record_to_title(record)
      MiniRocket.possible_resource_labels.each do |method|
        return record.send(method) if record.respond_to?(method)
      end

      record
    end

    def initialize(controller, params)
      @controller = controller
      @params = params
    end

    def mini_rocket?
      @mini_rocket ||= @controller.respond_to?(:mini_rocket?)
    end

    def render
      ::I18n.t(translation_key, context.merge!(default: [fallback_key, MiniRocket.site_title]))
    end

    def translation_key
      :"mini_rocket.page_title.#{controller_name}.#{action_name}"
    end

    def fallback_key
      return unless mini_rocket?

      :"mini_rocket.page_title.resources.#{action_name}"
    end

    def action_name
      @action_name ||= (ACTION_ALIASES[@controller.action_name.to_sym] || @controller.action_name)
    end

    def controller_name
      @controller_name ||= @controller.controller_name
    end

    def context
      return {} unless mini_rocket?

      normalize_assigns(@controller.view_assigns).merge(
        resource_name: @controller.send(:resource_class).name
      )
    end

    protected

    def normalize_assigns(assigns)
      assigns.each do |key, value|
        assigns[key] = (value.is_a?(ActiveRecord::Base) ? self.class.record_to_title(value) : value)
      end

      assigns.symbolize_keys
    end
  end
end
