module MiniRocket
  module Components
    class ColumnActions < Column
      def title
        @title ||= I18n.t('cleancms.label.actions')
      end

      def render(resource, template)
        template.render(partial: 'index_actions', locals: { resource: resource })
      end

      def sortable?
        false
      end
    end
  end
end