module Automux
  module Controller
    class Recipes < Base
      before_filter :load_recipe, only: :automate
      before_filter :load_blueprint, only: :automate
      before_filter :check_blueprint, only: :automate
      before_filter :load_and_setup_session, only: :automate

      def automate
        @binding = @session.get_binding
        render @recipe.path
      end

      private ###

      def load_recipe
        @recipe = Automux::Cache::Recipe.find_by_name(params[:recipe_name])
      end

      def load_blueprint
        @blueprint = Automux::Cache::Blueprint.find_by_name(params[:blueprint_name])
      end

      def check_blueprint
        notify_error 'No matching blueprint found' if @blueprint.nil?
      end

      def load_and_setup_session
        @session = Automux::Core::Tmux::Session.new(@blueprint.read)
        @session.setup_windows_and_hooks
      end
    end
  end
end
