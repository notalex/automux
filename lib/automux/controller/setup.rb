module Automux
  module Controller
    class Setup < Base

      def clone_defaults
        @binding = binding
        render 'clone_defaults'
      end
    end
  end
end
