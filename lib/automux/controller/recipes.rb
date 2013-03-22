module Automux
  module Controller
    class Recipes < Base
      before_filter :load_recipe, :automate
      before_filter :load_blueprint, :automate
      before_filter :load_session, :automate

      def automate
        render Automux::Library::MiniErb.new(@recipe.read).result(@session.get_binding)
      end

      private ###

      def load_recipe
        @recipe = Automux::Base::Recipe.new(params[:recipe_name])
      end

      def load_blueprint
        @blueprint = Automux::Base::Blueprint::new(params[:blueprint_name])
      end

      def load_session
        @session = Automux::Base::Tmux::Session.new(@blueprint.read)
      end

      self.superclass.after_inherited(self)
    end
  end
end
