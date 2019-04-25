require 'active_support/dependencies/autoload'

module MiniRocket
  module Formatters
    extend ActiveSupport::Autoload

    autoload :BaseFormat, 'cleancms/formatters/base_format'
    autoload :DefaultFormat, 'cleancms/formatters/default_format'
    autoload :BooleanFormat, 'cleancms/formatters/boolean_format'
    autoload :StringFormat, 'cleancms/formatters/string_format'
    autoload :FixnumFormat, 'cleancms/formatters/fixnum_format'
    autoload :IdFormat, 'cleancms/formatters/id_format'
    autoload :TimeFormat, 'cleancms/formatters/time_format'
    autoload :StatusFormat, 'cleancms/formatters/status_format'

    def self.build(resource, method_name, options = {})
      options[:object] ||= resource.send(method_name)

      klass = find_klass_by_value(options[:as])
      klass ||= find_klass_by_object(options[:object])
      klass ||= DefaultFormat

      klass.new(resource, method_name, options)
    end

    def self.find_klass_by_value(value)
      case value
      when Symbol then
        "MiniRocket::Formatters::#{value.to_s.classify}Format".safe_constantize
      when String then
        value.safe_constantize
      else
        value
      end
    end

    def self.find_klass_by_object(object)
      value = object.class.name
      value = 'Boolean' if %w(FalseClass TrueClass).include?(value)
      value = 'String' if %(NilClass Float).include?(value)

      "MiniRocket::Formatters::#{value}Format".safe_constantize
    end
  end
end
