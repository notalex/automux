module Automux
  module Redirector
    class Blueprint
      attr_reader :action, :blueprint_name, :clone_name

      def initialize(args)
        @action = args[1]
        @blueprint_name = args[2]
        @clone_name = args[3]
      end

      def redirect
        Automux::Controller::Blueprints.new(params).public_send(action)
      end

      private ###

      def params
        { blueprint_name: blueprint_name, clone_name: clone_name }
      end
    end
  end
end
