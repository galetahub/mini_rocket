# frozen_string_literal: true

require 'active_model'

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

    def method_missing(method_name, *args, &block)
      if method_name.to_s.include?('=')
        super
      else
        read_attribute(method_name)
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      !method_name.to_s.include?('=')
    end

    def self.model_name
      ActiveModel::Name.new(self, nil, 'Filter')
    end

    protected

    def read_attribute(method_name)
      return unless @params

      @params[method_name]
    end
  end
end
