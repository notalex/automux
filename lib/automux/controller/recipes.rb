module Automux
  module Controller
    class Recipes < Base
      before_filter :load_recipe, only: :automate
      before_filter :load_blueprint, only: :automate
      before_filter :load_and_setup_session, only: :automate

      def automate
        render Automux::Library::MiniErb.new(@recipe.read).result(@session.get_binding)
      end

      private ###

      def load_recipe
        @recipe = Automux::Core::Recipe.new(params[:recipe_name])
      end

      def load_blueprint
        @blueprint = Automux::Core::Blueprint::new(params[:blueprint_name])
      end

      def load_and_setup_session
        @session = Automux::Core::Tmux::Session.new(@blueprint.read)
        @session.setup_windows
      end

      self.superclass.after_inherited(self)
    end
  end
end
