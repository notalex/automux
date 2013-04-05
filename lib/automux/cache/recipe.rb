module Automux
  module Cache
    module Recipe
      extend self

      Instances = {}

      def setup
        user_and_default_recipe_paths.each do |path|
          recipe = Automux::Core::Recipe.new(path)
          Instances[recipe.name] = recipe
        end

        Instances[nil] = Instances['default']
      end

      def find_by_name(name)
        Instances[name] || Automux::Null::Recipe.new(name)
      end

      private ###

      # Default recipe overwrites any user defined recipe having the same name.
      def user_and_default_recipe_paths
        Automux::Paths.recipes.push(Automux::Paths.default_recipe)
      end
    end
  end
end
