# frozen_string_literal: true

module MiniRocket
  module Components
    class Scope
      attr_reader :name, :options
      attr_accessor :id

      def initialize(name, options = {}, &block)
        @name = name
        @options = options
        @block = block
      end

      def to_param
        return nil if @id.zero?

        uuid
      end

      def uuid
        @uuid ||= @id.to_s
      end

      def title
        @title ||= (options[:title] || @name.to_s.humanize)
      end

      def configure(collection, params = {})
        @collection = collection
        @active = ((params[:scope] == uuid) || (params[:scope].blank? && default?))
      end

      def active?
        @active
      end

      def default?
        options[:default]
      end

      def count
        @count ||= collection_scope.count
      end

      def collection_scope
        @collection_scope ||= fetch_collection_scope
      end

      private

      def fetch_collection_scope
        if @block
          @block.call(@collection)
        elsif @collection.respond_to?(name)
          @collection.public_send(name)
        else
          @collection
        end
      end
    end
  end
end
