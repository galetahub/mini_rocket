# frozen_string_literal: true

module MiniRocket
  class ActionBuilder
    attr_reader :index, :form, :show, :filter, :navigation, :sidebars, :reorder, :scopes

    def initialize
      @index = nil
      @form = nil
      @show = nil
      @filter = nil
      @navigation = nil
      @reorder = nil
      @scopes = nil

      @sidebars = []
      @options = {}
    end

    def build_index(options = {}, &block)
      options = { pagination: true }.merge!(options)
      @index = Actions::Index.new(options, &block)
    end

    def build_reorder(options = {}, &block)
      @reorder = Actions::Reorder.new(options, &block)
    end

    def build_show(options = {}, &block)
      @show = Actions::Show.new(options, &block)
    end

    def build_form(options = {}, &block)
      @form = Actions::Form.new(options, &block)
    end

    def build_filter(options = {}, &block)
      @filter = Actions::Filter.new(options, &block)
    end

    def build_scopes(options = {}, &block)
      @scopes = Actions::Scopes.new(options, &block)
    end

    def build_sidebar(name, options = {}, &block)
      @sidebars << Actions::Sidebar.new(options.merge(name: name), &block)
    end

    def build_navigation(options = {}, &block)
      @navigation = Actions::Navigation.new(options, &block)
    end

    def sidebars_via_action(action_name)
      @sidebars.select { |sidebar| sidebar.include?(action_name) }
    end

    def filter?
      !@filter.nil?
    end

    def index?
      !@index.nil?
    end

    def reorder?
      !@reorder.nil?
    end

    def show?
      !@show.nil?
    end

    def new?
      true
    end

    def navigation?
      !@navigation.nil?
    end

    def scopes?
      !@scopes.nil?
    end

    def update_options(options)
      return if options.nil?

      @options.merge!(options)
    end
  end
end
