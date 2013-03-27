module Automux
  module Controller
    class Blueprints < Base
      before_filter :load_blueprint, only: :edit

      def edit
        @binding = @blueprint.get_binding
        render 'edit'
      end

      private ###

      def load_blueprint
        @blueprint = Automux::Cache::Blueprint.find_by_name(params[:name])
      end
    end
  end
end
