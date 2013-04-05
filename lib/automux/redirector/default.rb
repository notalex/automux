module Automux
  module Redirector
    class Default
      attr_reader :blueprint_name, :recipe_name, :options

      def initialize(argv)
        args = argv.take_while { |argument| argument.match(/^\w/) }
        @blueprint_name = args[0] || 'default'
        @recipe_name = args[1] || 'default'
        @options = get_options(argv)
      end

      def redirect
        Automux::Controller::Recipes.new(params).automate
      end

      private ###

      def get_options(argv)
        blueprint = Automux::Cache::Blueprint.find_by_name(blueprint_name)
        Automux::Library::FileOptionsParser.new(blueprint.path, argv).getopts
      end

      def params
        { blueprint_name: blueprint_name, recipe_name: recipe_name, options: options }
      end
    end
  end
end
