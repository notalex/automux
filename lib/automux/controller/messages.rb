module Automux
  module Controller
    class Messages < Base
      def error
        error = Automux::Core::Error.new(params[:message])
        @binding = error.get_binding
        render 'error'
      end
    end
  end
end
