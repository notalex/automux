module Automux
  module Cache
    module Recipe
      extend self

      Instances = {}

      def setup
        Automux::Paths.recipes.each do |path|
          recipe = Automux::Core::Recipe.new(path)
          Instances[recipe.name] = recipe
        end
      end

      def find_by_name(name)
        Instances[name]
      end
    end
  end
end
