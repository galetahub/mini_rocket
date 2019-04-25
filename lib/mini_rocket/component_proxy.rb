# frozen_string_literal: true

module MiniRocket
  class ComponentProxy
    def split_string_on(string, match)
      return '' unless string && match

      first_part = string.split(Regexp.new("#{match}\\z")).first
      [first_part, match]
    end

    def opening_tag
      @opening_tag || ''
    end

    def closing_tag
      @closing_tag || ''
    end

    def children
      @children ||= ''.html_safe
    end

    def to_s
      (opening_tag << children.to_s << closing_tag).html_safe
    end
  end
end
