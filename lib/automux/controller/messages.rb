module Automux
  module Controller
    class Messages < Base     # :nodoc:
      def error
        error = Automux::Core::Error.new(params[:message])
        @binding = error.get_binding
        render 'error'
      end
    end
  end
end
