module MiniRocket
  class UrlBuilder
    ID = ':id'.freeze
    PARENT = ':parent_id'.freeze

    attr_reader :pattern, :target, :options

    def initialize(pattern, target, *args)
      @options = args.extract_options!
      @parent = args[0] if args.size > 1
      @resource = args.last
      @pattern = pattern.dup
      @target = target
    end

    def resource
      @resource ||= target.send(:resource)
    end

    def parent
      @parent ||= target.send(:parent)
    end

    def to_path
      pattern.gsub!(ID, resource.to_param) if pattern.include?(ID)
      pattern.gsub!(PARENT, parent.to_param) if pattern.include?(PARENT)
      pattern
    end
  end
end
