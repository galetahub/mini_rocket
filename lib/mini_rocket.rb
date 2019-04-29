# frozen_string_literal: true

require 'active_support/dependencies/autoload'
require 'mini_rocket/version'

module MiniRocket
  extend ActiveSupport::Autoload

  autoload :Controller, 'mini_rocket/controller'
  autoload :ActionBuilder, 'mini_rocket/action_builder'
  autoload :ComponentProxy, 'mini_rocket/component_proxy'
  autoload :FormProxy, 'mini_rocket/form_proxy'
  autoload :FilterProxy, 'mini_rocket/filter_proxy'
  autoload :Formatters, 'mini_rocket/formatters'
  autoload :Titleizer, 'mini_rocket/titleizer'
  autoload :ScopedQuery, 'mini_rocket/scoped_query'
  autoload :SortingQuery, 'mini_rocket/sorting_query'
  autoload :SortingParser, 'mini_rocket/sorting_parser'
  autoload :FilterForm, 'mini_rocket/filter_form'

  module Actions
    autoload :Base, 'mini_rocket/actions/base'
    autoload :Index, 'mini_rocket/actions/index'
    autoload :Show, 'mini_rocket/actions/show'
    autoload :Form, 'mini_rocket/actions/form'
    autoload :Filter, 'mini_rocket/actions/filter'
    autoload :Sidebar, 'mini_rocket/actions/sidebar'
    autoload :Navigation, 'mini_rocket/actions/navigation'
    autoload :Reorder, 'mini_rocket/actions/reorder'
    autoload :Scopes, 'mini_rocket/actions/scopes'
    autoload :PermitedParams, 'mini_rocket/actions/permited_params'
  end

  module Components
    autoload :Holder, 'mini_rocket/components/holder'
    autoload :SectionFor, 'mini_rocket/components/section_for'
    autoload :AttributesTableFor, 'mini_rocket/components/attributes_table_for'
    autoload :Column, 'mini_rocket/components/column'
    autoload :Columnable, 'mini_rocket/components/columnable'
    autoload :ColumnActions, 'mini_rocket/components/column_actions'
    autoload :ReorderableColumn, 'mini_rocket/components/reorderable_column'
    autoload :Panelable, 'mini_rocket/components/panelable'
    autoload :Scope, 'mini_rocket/components/scope'
  end

  mattr_accessor :possible_resource_labels
  self.possible_resource_labels = %w[label name title id].freeze

  mattr_accessor :namespace
  self.namespace = :manage

  mattr_accessor :site_title
  self.site_title = 'Admin panel'

  mattr_accessor :sortable
  self.sortable = false

  mattr_accessor :paginates_per
  self.paginates_per = 25

  def self.setup
    yield self
  end
end

require 'mini_rocket/rails'
