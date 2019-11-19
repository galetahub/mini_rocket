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
    autoload :TemplateResolver, 'mini_rocket/controller/template_resolver'

    LAYOUT = 'mini_rocket/application'
    VIEWS_PATH = 'app/views/mini_rocket/resources'

    included do
      include MiniRocket::Controller::BaseHelpers
      include MiniRocket::Controller::UrlHelpers

      layout MiniRocket::Controller::LAYOUT

      before_action :setup_mini_rocket_views_path

      responders :flash, :http_cache
      inherit_resources

      helper_method :rocket_builder, :parent?, :mini_rocket?, :controller_namespace,
                    :scoped_collection, :sortable_collection, :paginated_collection,
                    :collection_or_resource_path, :cancel_path, :collection_or_parent_path

      class_attribute :rocket_store, instance_writer: false
      self.rocket_store = {}
    end

    module ClassMethods
      def index(options = {}, &block)
        rocket_builder.build_index(options, &block)
      end

      def reorder(options = {}, &block)
        rocket_builder.build_reorder(options, &block)

        custom_actions collection: %i[reorder reposition]

        define_method(:reposition) do
          update_collection_order(resource_class, params)
          flash[:notice] = I18n.t('flash.actions.reposition.notice', resource_name: resource_class.name)
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

      def permit_params(*args)
        rocket_builder.build_permited_params(*args)

        define_method :build_resource_params do
          rocket_builder.permited_params.permit(resource_class, params)
        end

        private :build_resource_params
      end

      def rocket_options(options = {})
        rocket_builder.update_options(options)
      end

      def rocket_builder
        rocket_store[controller_path] ||= ActionBuilder.new
      end
    end

    private

    def rocket_builder
      rocket_store[controller_path]
    end

    def setup_mini_rocket_views_path
      append_view_path MiniRocket::Controller::TemplateResolver.new(
        MiniRocket::Engine.root.join(VIEWS_PATH)
      )
    end
  end
end
