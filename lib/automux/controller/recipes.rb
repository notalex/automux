module Automux
  module Controller
    class Recipes < Base     # :nodoc:
      before_filter :load_recipe, only: :automate
      before_filter :load_blueprint, only: :automate
      before_filter :check_blueprint, only: :automate
      before_filter :check_recipe, only: :automate
      before_filter :load_and_setup_session, only: :automate

      def automate
        @binding = @session.get_binding
        render_file @recipe.path
      end

      private ###

      def load_recipe
        @recipe = Automux::Cache::Recipe.find_by_name(params[:recipe_name])
      end

      def load_blueprint
        @blueprint = Automux::Cache::Blueprint.find_by_name(params[:blueprint_name])
      end

      def check_recipe
        notify_error "Unable to find recipe named #{ @recipe.name }.sh.erb" if @recipe.is_a?(Automux::Null::Recipe)
      end

      def load_and_setup_session
        @session = Automux::Core::Tmux::Session.new(@blueprint.read(params[:options]))
        @session.setup
      end
    end
  end
end
