module Automux
  module Controller
    class Base     # :nodoc:
      include Support::Rendering
      extend Support::Filters

      attr_reader :params

      def initialize(params = {})
        @params = params
      end

      def notify_error(message)
        Automux::Controller::Messages.new(message: message).error
      end

      def check_blueprint
        notify_error "Unable to find blueprint named #{ @blueprint.name }.yml" if @blueprint.is_a?(Automux::Null::Blueprint)
      end
    end
  end
end
