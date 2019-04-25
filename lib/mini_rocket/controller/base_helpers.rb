module MiniRocket
  module Controller
    module BaseHelpers
      protected

      def collection
        read_collection_ivar || write_collection_ivar(scoped_collection)
      end

      def scoped_collection
        @scoped_collection ||= ScopedQuery.new(end_of_association_chain, params, cleancms_builder).to_query
      end

      def sortable_collection
        @sortable_collection ||= SortingQuery.new(collection, params, cleancms_builder).to_query
      end

      # This is how the resource is loaded.
      #
      # You might want to overwrite this method when you are using permalink.
      # When you do that, don't forget to cache the result in an
      # instance_variable:
      #
      #   def resource
      #     @project ||= end_of_association_chain.find_by_permalink!(params[:id])
      #   end
      #
      # You also might want to add the exclamation mark at the end of the method
      # because it will raise a 404 if nothing can be found. Otherwise it will
      # probably render a 500 error message.
      #
      def resource
        read_resource_ivar || write_resource_ivar(end_of_association_chain.send(method_for_find, params[:id]))
      end

      def resource_collection_name
        cleancms_builder.collection_name
      end

      def resource_instance_name
        cleancms_builder.instance_name
      end

      def parent_instance_name
        cleancms_builder.parent_instance_name
      end

      def resource_human_name
        resource_class.model_name.human
      end

      # Get collection ivar based on the current resource controller.
      #
      def read_collection_ivar #:nodoc:
        instance_variable_get("@#{resource_collection_name}")
      end

      # Set collection ivar based on the current resource controller.
      #
      def write_collection_ivar(collection) #:nodoc:
        collection = collection.page(params[:page]) if cleancms_builder.index.pagination?
        instance_variable_set("@#{resource_collection_name}", collection)
      end

      def end_of_association_chain
        cleancms_builder.collection
      end

      def resource_class
        cleancms_builder.klass
      end

      def parent?
        !parent.nil?
      end

      def parent_klass
        cleancms_builder.parent_klass
      end

      def parent
        return unless cleancms_builder.parent?
        read_parent_ivar ||
          write_parent_ivar(parent_klass.find(params[parent_param_name]))
      end

      def parent_param_name
        parent_klass.to_s.foreign_key
      end

      # This method is responsible for building the object on :new and :create
      # methods. If you overwrite it, don't forget to cache the result in an
      # instance variable.
      #
      def build_resource
        read_resource_ivar || write_resource_ivar(build_new_resource)
      end

      # Get resource ivar based on the current resource controller.
      #
      def read_resource_ivar #:nodoc:
        instance_variable_get("@#{resource_instance_name}")
      end

      def write_resource_ivar(resource)
        instance_variable_set("@#{resource_instance_name}", resource)
      end

      # Get parent ivar based on the parent resource class.
      #
      def read_parent_ivar #:nodoc:
        instance_variable_get("@#{parent_instance_name}")
      end

      def write_parent_ivar(resource)
        instance_variable_set("@#{parent_instance_name}", resource)
      end

      def resource_params
        send(resource_params_method_name)
      rescue ActionController::ParameterMissing
        return {} if action_name.to_sym == :new
        raise
      end

      def resource_params_method_name
        @resource_params_method_name ||= "#{resource_instance_name}_params"
      end

      def build_new_resource
        end_of_association_chain.send(method_for_build, resource_params)
      end

      def method_for_build
        :new
      end

      def method_for_find
        :find
      end

      def create_resource(object, new_attributes)
        update_resource(object, new_attributes)
      end

      def update_resource(object, new_attributes)
        object.update_attributes(new_attributes)
      end

      def destroy_resource(object)
        object.destroy
      end

      def update_collection_order(resource_class, params)
        reorder_params = params.require(:items).map { |item| item.permit(:id, :sort_order) }

        reorder_ids        = reorder_params.map { |item| item[:id] }
        reorder_attributes = reorder_params.map { |item| item.slice(:sort_order) }

        resource_class.update(reorder_ids, reorder_attributes)
      end
    end
  end
end
