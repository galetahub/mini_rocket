# frozen_string_literal: true

require 'action_view/template/resolver'

module MiniRocket
  module Controller
    class TemplateResolver < ::ActionView::FileSystemResolver
      VIEWS_PATTERN = ':action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}'

      private

      # Helper for building query glob string based on resolver's pattern.
      def build_query(path, details)
        query = VIEWS_PATTERN.dup

        partial = escape_entry(path.partial? ? "_#{path.name}" : path.name)
        query.gsub!(':action', partial)

        details.each do |ext, candidates|
          if ext == :variants && candidates == :any
            query.gsub!(/:#{ext}/, '*')
          else
            query.gsub!(/:#{ext}/, "{#{candidates.compact.uniq.join(',')}}")
          end
        end

        File.expand_path(query, @path)
      end
    end
  end
end
