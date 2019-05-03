# frozen_string_literal: true

module MiniRocket
  module Actions
    class Form < Base
      DEFAULTS = {
        builder: MiniRocket::Controller::FormBuilder,
        wrapper: :mini_rocket
      }.freeze

      def html_options
        DEFAULTS.merge(options)
      end
    end
  end
end
