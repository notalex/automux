module Automux
  module Core
    class Error
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def get_binding # :nodoc:
        binding
      end
    end
  end
end
