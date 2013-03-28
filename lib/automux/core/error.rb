module Automux
  module Core
    class Error
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def get_binding
        binding
      end
    end
  end
end
