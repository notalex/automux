module Automux
  module Controller
    class Blueprints < Base
      before_filter :load_blueprint, only: [:edit, :copy, :cp, :delete, :rm]

      # blueprint_name.yml will be searched under $HOME/.automux/blueprints
      # $ automux blueprint edit blueprint_name
      def edit
        @binding = @blueprint.get_binding
        render 'edit'
      end

      # This copies the content from default.yml and opens the new file using $EDITOR
      # $ automux blueprint create new_blueprint_name
      def create
        blueprint = Automux::Core::Blueprint.build_by_name(params[:blueprint_name])
        blueprint.source = Automux::Cache::Blueprint.find_by_name('default')
        @binding = blueprint.get_binding
        render 'create'
      end

      # $ automux blueprint copy source destination
      def copy
        clone_blueprint = Automux::Core::Blueprint.build_by_name(params[:clone_name])
        clone_blueprint.source = @blueprint
        @binding = clone_blueprint.get_binding
        render 'copy'
      end
      alias_method :cp, :copy

      # $ automux blueprint delete some_blueprint
      def delete
        @binding = @blueprint.get_binding
        render 'delete'
      end
      alias_method :rm, :delete

      private ###

      def load_blueprint
        @blueprint = Automux::Cache::Blueprint.find_by_name(params[:blueprint_name])
      end
    end
  end
end
