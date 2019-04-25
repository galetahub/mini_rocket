# frozen_string_literal: true

require 'inherited_resources'

module MiniRocket
  module Controller
    extend ActiveSupport::Concern

    autoload :BaseHelpers, 'mini_rocket/controller/base_helpers'
    autoload :ViewHelpers, 'mini_rocket/controller/view_helpers'
    autoload :UrlHelpers, 'mini_rocket/controller/url_helpers'
    autoload :FormBuilder, 'mini_rocket/controller/form_builder'
    autoload :LocalizationBuilder, 'mini_rocket/controller/localization_builder'
    autoload :NestedAttributesBuilder, 'mini_rocket/controller/nested_attributes_builder'

    LAYOUT = 'mini_rocket/application'
    SIMPLE_LAYOUT = 'mini_rocket/simple'

    VIEWS_PATH = 'app/views/mini_rocket/resources'
    VIEWS_PATTERN = ':action{.:locale,}{.:formats,}{+:variants,}{.:handlers,}'

    included do
      layout MiniRocket::Controller::LAYOUT

      before_action :setup_cleancms_views_path

      responders :flash, :http_cache
      inherit_resources

      helper_method :rocket_builder, :parent?

      class_attribute :rocket_store, instance_writer: false
      self.rocket_store = {}
    end

    module ClassMethods
      def index(options = {}, &block)
        rocket_builder.build_index(options, &block)
      end

      def reorder(options = {}, &block)
        rocket_builder.build_reorder(options, &block)

        define_method(:reorder) { render layout: SIMPLE_LAYOUT }

        define_method(:reposition) do
          update_collection_order(resource_class, params)
          flash[:notice] = I18n.t('flash.actions.reposition.notice', resource_name: resource_human_name)
          render json: { status: 'success' }
        end

        respond_to :json, only: :reposition
      end

      def show(options = {}, &block)
        rocket_builder.build_show(options, &block)
      end

      def form(options = {}, &block)
        rocket_builder.build_form(options, &block)
      end

      def create(options = {}, &block)
        options = { only: [:new, :create] }.merge!(options)
        form(options, &block)
      end

      def update(options = {}, &block)
        options = { only: [:edit, :update, :destroy] }.merge!(options)
        form(options, &block)
      end

      def filter(options = {}, &block)
        rocket_builder.build_filter(options, &block)
      end

      def scopes(options = {}, &block)
        rocket_builder.build_scopes(options, &block)
      end

      def sidebar(name, options = {}, &block)
        rocket_builder.build_sidebar(name, options, &block)
      end

      def navigation(options = {}, &block)
        rocket_builder.build_navigation(options, &block)
      end

      def rocket_options(options = {})
        rocket_builder.update_options(options)
      end

      def rocket_builder
        rocket_store[controller_name] ||= ActionBuilder.new
      end
    end

    def mini_rocket?
      true
    end

    protected

    # Parent is always false only true when belongs_to is called.
    #
    def parent?
      false
    end

    private

    def rocket_builder
      rocket_store[controller_name]
    end

    def setup_cleancms_views_path
      append_view_path ::ActionView::FileSystemResolver.new(
        MiniRocket::Engine.root.join(VIEWS_PATH),
        VIEWS_PATTERN
      )
    end
  end
end
