module Automux
  module Controller
    class Blueprints < Base
      before_filter :load_blueprint, only: [:edit, :copy]

      def edit
        @binding = @blueprint.get_binding
        render 'edit'
      end

      def create
        blueprint = Automux::Core::Blueprint.build_by_name(params[:name])
        @binding = blueprint.get_binding
        render 'create'
      end

      def copy
        clone_blueprint = Automux::Core::Blueprint.build_by_name(params[:clone_name])
        clone_blueprint.source = @blueprint
        @binding = clone_blueprint.get_binding
        render 'copy'
      end

      private ###

      def load_blueprint
        @blueprint = Automux::Cache::Blueprint.find_by_name(params[:name])
      end
    end
  end
end
