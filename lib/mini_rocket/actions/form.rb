# frozen_string_literal: true

module MiniRocket
  module Actions
    class Form < Base
      DEFAULTS = {
        builder: MiniRocket::Controller::FormBuilder,
        wrapper: :cleancms
      }.freeze

      def html_options
        DEFAULTS.merge(options)
      end
    end
  end
end
