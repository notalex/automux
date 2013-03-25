module Automux
  module Core
    class Hook
      PRE = 2
      POST = 4

      attr_reader :command, :type
      private :type

      def initialize(type, command)
        @type = self.class.const_get(type.upcase)
        @command = command
      end

      def pre?
        type == PRE
      end

      def post?
        type == POST
      end
    end
  end
end
