require 'mini_rocket/components/holder'

module MiniRocket
  module Actions
    class Show < Base
      def render(resource, template)
        holder = MiniRocket::Components::Holder.new({ resource: resource }, template)
        holder.build(&@block)
      end
    end
  end
end
