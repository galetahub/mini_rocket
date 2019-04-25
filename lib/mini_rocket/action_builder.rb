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
      @form && @form.avaiable_action?(:new)
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

    def klass
      @options[:class]
    end

    def collection
      @collection ||= build_collection
    end

    def collection_name
      @options[:collection_name] || klass.model_name.plural
    end

    def instance_name
      @options[:instance_name] || klass.model_name.singular
    end

    def route_instance_name
      @options[:route_instance_name] || instance_name
    end

    def route_collection_name
      @options[:route_collection_name] || collection_name
    end

    def parent?
      !parent_klass.nil?
    end

    def parent_klass
      @options[:parent_class]
    end

    def parent_collection_name
      @options[:parent_collection_name] || parent_klass.model_name.plural
    end

    def parent_instance_name
      @options[:parent_instance_name] || parent_klass.model_name.singular
    end

    def index!
      @index.call if index?
      @scopes.call if scopes?
    end

    protected

    def build_collection
      return @options[:collection].call if @options[:collection]
      @options[:class].all
    end
  end
end
