module MiniRocket
  module Controller
    # = URLHelpers
    #
    # When you use MiniRocket it creates some UrlHelpers for you.
    # And they handle everything for you.
    #
    #  # /posts/1/comments
    #  resource_path          # => /posts/1/comments/#{@comment.to_param}
    #  resource_path(comment) # => /posts/1/comments/#{@comment.to_param}
    #  new_resource_path      # => /posts/1/comments/new
    #  edit_resource_path     # => /posts/1/comments/#{@comment.to_param}/edit
    #  collection_path        # => /posts/1/comments
    #  parent_path            # => /posts/1
    #
    #  # /users
    #  resource_path          # => /users/#{user.to_param}
    #  resource_path(user)    # => /users/#{user.to_param}
    #  new_resource_path      # => /users/new
    #  edit_resource_path     # => /users/#{user.to_param}/edit
    #  collection_path        # => /users
    #  parent_path            # => /
    #
    # The nice thing is that those urls are not guessed during runtime. They are
    # all created when you inherit.
    #
    module UrlHelpers
      PATTERNS = {
        general: {
          resource_path: '/:namespace/:route_collection_name/:id',
          new_resource_path: '/:namespace/:route_collection_name/new',
          edit_resource_path: '/:namespace/:route_collection_name/:id/edit',
          collection_path: '/:namespace/:route_collection_name',
          parent_path: '/:namespace/:parent_collection_name/:parent_id',
          reorder_collection_path: '/:namespace/:route_collection_name/reorder',
          reposition_collection_path: '/:namespace/:route_collection_name/reposition'
        }
      }.freeze

      module InstanceMethods
        def collection_or_resource_path(*args)
          if cleancms_builder.show?
            resource_path(*args)
          else
            collection_path
          end
        end

        def cancel_path
          record = read_resource_ivar

          if cleancms_builder.show? && record.persisted?
            resource_path(record)
          elsif cleancms_builder.index?
            collection_path
          elsif parent?
            parent_path
          end
        end

        def collection_or_parent_path
          if cleancms_builder.index?
            collection_path
          elsif parent?
            parent_path
          end
        end
      end

      protected

      def create_resources_path_helpers!
        PATTERNS[:general].each do |key, pattern|
          defined_path_helper(key, pattern)
        end

        include InstanceMethods
      end

      def defined_path_helper(method_name, pattern) #:nodoc:
        return if method_defined?(method_name)

        cached_pattern = build_path_url_from_pattern(pattern)

        define_method(method_name) do |*args|
          MiniRocket::UrlBuilder.new(cached_pattern, self, args).to_path
        end
      end

      def build_path_url_from_pattern(pattern)
        value = pattern.gsub(':namespace', MiniRocket.namespace.to_s)
        value.gsub!(':route_collection_name', cleancms_builder.route_collection_name.to_s)

        if cleancms_builder.parent?
          value.gsub!(':parent_collection_name', cleancms_builder.parent_collection_name.to_s)
        end

        value
      end
    end
  end
end
