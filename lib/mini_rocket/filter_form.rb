# frozen_string_literal: true

require 'active_model'
require 'active_model/type'

module MiniRocket
  class FilterForm
    extend ActiveModel::Naming
    extend ActiveModel::Translation
    include ActiveModel::Conversion

    attr_reader :params

    def initialize(params = {})
      @params = params
    end

    def persisted?
      false
    end

    def new_record?
      !persisted?
    end

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    def has_attribute?(attribute)
      attribute.present?
    end

    # By default all fields are strings
    #
    def type_for_attribute(_attribute)
      ActiveModel::Type.lookup(:string, limit: 200)
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s.include?('=')
        super
      else
        read_attribute(method_name)
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      params_key?(attribute) || super
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, 'Filter')
    end

    private

    def params_key?(attribute)
      return unless @params

      @params.key?(attribute)
    end

    def read_attribute(method_name)
      return unless @params

      @params[method_name]
    end
  end
end
