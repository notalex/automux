require 'erb'

module Automux
  module Core
    class Hook
      PRE = 2
      POST = 4

      attr_reader :command, :type
      private :type

      def initialize(target, type, command)
        @type = self.class.const_get(type.upcase)
        @command = ERB.new(command).result(target.get_binding)
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
