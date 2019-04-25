# frozen_string_literal: true

require 'securerandom'

module MiniRocket
  module Actions
    # Build subnavigation menu
    # Usage:
    #
    #   navigation do
    #     Satellite.group(:currency).count.each do |currency, count|
    #       menu "#{currency} (#{count})", currency: currency
    #     end
    #   end
    #
    class Navigation < Base
      class Menu
        def initialize(name, path, options = {})
          @name = name
          @path = path
          @options = options
        end

        def id
          @id ||= "menu_#{SecureRandom.uuid}"
        end

        def render(template)
          @options[:class] = Array(@options[:class])
          @options[:class] << 'selected' if template.current_page?(@path)

          template.link_to(@name, @path, @options)
        end
      end

      def each_menu
        @links = []
        instance_exec(&@block)

        @links.each do |link|
          yield link
        end
      end

      def menu(name, path, options = {})
        @links << Menu.new(name, path, options)
      end
    end
  end
end
