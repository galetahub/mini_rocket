module MiniRocket
  module Actions
    class Filter < Base
      DEFAULTS = {
        method: :get,
        class: 'filter-form no-margin'
      }.freeze

      def html_options
        DEFAULTS.merge(options)
      end
    end
  end
end
