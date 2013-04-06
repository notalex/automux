module Automux
  module Redirector
    class Default
      attr_reader :blueprint_name, :recipe_name, :options

      def initialize(argv)
        @blueprint_name = non_opt_argument_or_nil(argv[0])
        @options = get_options
        @recipe_name = argv[1]
      end

      def redirect
        Automux::Controller::Recipes.new(params).automate
      end

      private ###

      def get_options
        blueprint = Automux::Cache::Blueprint.find_by_name(blueprint_name)
        Automux::Library::FileOptionsParser.new(blueprint.path).getopts
      end

      def params
        { blueprint_name: blueprint_name, recipe_name: recipe_name, options: options }
      end

      def non_opt_argument_or_nil(value)
        value.slice(/^\w+$/)
      end
    end
  end
end
