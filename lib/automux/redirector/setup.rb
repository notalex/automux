module Automux
  module Redirector
    class Setup  # :nodoc:
      def initialize(args)
      end

      def redirect
        Automux::Controller::Setup.new.clone_defaults
      end
    end
  end
end
