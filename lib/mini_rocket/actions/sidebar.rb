module MiniRocket
  module Actions
    class Sidebar < Base
      def include?(action_name)
        return false if action_name.blank?
        options[:only].nil? || Array(options[:only]).include?(action_name.to_sym)
      end

      def render(template)
        template.instance_exec(&@block)
      end
    end
  end
end
