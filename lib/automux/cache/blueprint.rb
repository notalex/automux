module Automux
  module Cache
    module Blueprint
      extend self

      Instances = {}

      def setup
        Automux::Paths.blueprints.each do |path|
          blueprint = Automux::Core::Blueprint.new(path)
          Instances[blueprint.name] = blueprint
        end

        Instances[nil] = Instances['default']
      end

      def find_by_name(name)
        Instances[name] || Automux::Null::Blueprint.new(name)
      end
    end
  end
end
