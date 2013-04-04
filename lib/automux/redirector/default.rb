require 'optparse'

module Automux
  module Redirector
    class Default
      attr_reader :params

      def initialize(argv)
        args = argv.take_while { |argument| argument.match(/^\w/) }

        params = {
          blueprint_name: args[0] || 'default',
          recipe_name:    args[1] || 'default'
        }

        opts = (Automux::Cache::Blueprint.find_by_name(params[:blueprint_name]).opts rescue nil)
        argv.shift while argv[0].to_s.match(/^\w/)
        params[:options] = argv.getopts(*opts)

        @params = params
      end

      def redirect
        Automux::Controller::Recipes.new(params).automate
      end
    end
  end
end
