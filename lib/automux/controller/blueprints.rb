module Automux
  module Controller
    class Blueprints < Base
      before_filter :load_blueprint, only: [:edit, :copy, :cp, :delete, :rm]

      def edit
        @binding = @blueprint.get_binding
        render 'edit'
      end

      def create
        blueprint = Automux::Core::Blueprint.build_by_name(params[:name])
        blueprint.source = Automux::Cache::Blueprint.find_by_name('default')
        @binding = blueprint.get_binding
        render 'create'
      end

      def copy
        clone_blueprint = Automux::Core::Blueprint.build_by_name(params[:clone_name])
        clone_blueprint.source = @blueprint
        @binding = clone_blueprint.get_binding
        render 'copy'
      end
      alias_method :cp, :copy

      def delete
        @binding = @blueprint.get_binding
        render 'delete'
      end
      alias_method :rm, :delete

      private ###

      def load_blueprint
        @blueprint = Automux::Cache::Blueprint.find_by_name(params[:name])
      end
    end
  end
end
