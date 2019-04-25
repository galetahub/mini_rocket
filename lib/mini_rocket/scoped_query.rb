module MiniRocket
  # Apply active scope to collection query
  #
  class ScopedQuery
    def initialize(scope, params, builder = nil)
      @scope = scope
      @params = params
      @builder = builder
    end

    def to_query
      if active_scope?
        active_scope.configure(@builder.collection, @params)
        active_scope.collection_scope
      else
        @scope
      end
    end

    def active_scope?
      !active_scope.nil?
    end

    def active_scope
      return unless @builder.scopes?
      @active_scope ||= @builder.scopes.find_active(@params)
    end
  end
end
